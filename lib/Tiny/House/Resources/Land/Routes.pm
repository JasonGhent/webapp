use Dancer ':syntax';
use Dancer::Plugin::Database;

use File::Copy;

our $VERSION = '0.1';

prefix '/resources/land';

get '/' => sub {
	my $page = params->{'page'} || 1;

	my @places = schema->resultset('Place')->search(undef, {page => $page, rows => 50, order_by => {-asc => ['state', 'place']}});

	template 'resources/land', 
	{
		current_page => $page,
		entries_per_page => 10,
		places => \@places,
	};
};

get '/view/:id' => sub {
	my $place = schema->resultset('Place')->find({id => params->{'id'}});
	
	template 'resources/land/view', {place => $place};
};

get '/edit/:id' => sub {
	my $place = schema->resultset('Place')->find({id => params->{'id'}});
	
	template 'resources/land/edit', {place => $place};
};

post '/edit/:id' => sub {
	my $place = schema->resultset('Place')->find({id => params->{'id'}});

	foreach my $scrub ('adu_minimum_square_feet', 'foundation_minimum_square_feet', 'rv_minimum_square_feet')
	{
		if (exists(params->{$scrub}))
		{
			params->{$scrub} =~ s/\D//g;
		}
	}

	$place->place(params->{'place'});
	$place->state(params->{'state'});
	$place->adu_minimum_square_feet(params->{'adu_minimum_square_feet'} || undef);
	$place->foundation_minimum_square_feet(params->{'foundation_minimum_square_feet'} || undef);
	$place->rv_minimum_square_feet(params->{'rv_minimum_square_feet'} || undef);
	$place->notes(params->{'notes'} || undef);

	$place->update;

	return redirect '/resources/land/view/' . $place->id . '?alertSuccess=1&alertMessage=Your changes have been published.';
};
