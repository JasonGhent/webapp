use Dancer ':syntax';
use Dancer::Plugin::Database;

our $VERSION = '0.1';

prefix '/resources/land';

get '/' => sub {
	my $sth = database->prepare('
SELECT 
	*
FROM   
	places p1
WHERE  
	revision=

	(
		SELECT 
			MAX(p2.revision)
              
		FROM 
			places p2
              
		WHERE 
			p1.id = p2.id
	)
	');

	$sth->execute;

	my $places = $sth->fetchall_arrayref({});

	$sth = database->prepare('
SELECT 
	COUNT(*) AS awaiting_review 
FROM 
	places 
WHERE 
	revision >= 
	(
		SELECT 
			MAX(revision) 
		FROM 
			places 
		WHERE 
			approved = true
	) 
	AND 
	approved = false');

	$sth->execute;

	my $awaiting_review = $sth->fetchrow_array();

	template 'resources/land', {places => $places, awaiting_review => $awaiting_review};
};

get '/view/:land' => sub {
	my $place = database->quick_select('places', {id => params->{'land'}, approved => 1}, {order_by => { desc => 'revision'}});
	
	template 'resources/land/view', {place => $place};
};

get '/edit/:land' => sub {
	my $place = database->quick_select('places', {id => params->{'land'}, approved => 1}, {order_by => {desc => 'revision'}});
	
	template 'resources/land/edit', {place => $place};
};

post '/edit/:id' => sub {
	my $id = params->{'id'};
	my $insert_items = {id => $id};

	# Get existing KML
	my $row = database->quick_select('places', {id => $id, approved => 1}, {order_by => {desc => 'revision'}});
	$insert_items->{'kml'} = $row->{'kml'};

	if (exists(params->{'place'}))
	{
		$insert_items->{'place'} = params->{'place'};
	}

	if (exists(params->{'state'}))
	{
		$insert_items->{'state'} = params->{'state'};
	}

	if (exists(params->{'adu'}) && params->{'adu'} =~ /^\d+$/)
	{
		$insert_items->{'adu_minimum_square_feet'} = params->{'adu'};
	}

	if (exists(params->{'foundation'}) && params->{'foundation'} =~ /^\d+$/)
	{
		$insert_items->{'foundation_minimum_square_feet'} = params->{'foundation'};
	}

	if (exists(params->{'mobile'}) && params->{'mobile'} =~ /^\d+$/)
	{
		$insert_items->{'trailer_minimum_square_feet'} = params->{'mobile'};
	}

	if (scalar(keys(%{$insert_items})) >= 1 && database->quick_insert('places', $insert_items))
	{
		return redirect '/resources/land/view/' . $id . '?alertSuccess=1&alertMessage=Your changes have been submitted for review.';
	}

	return redirect '/?alertSuccess=0&alertMessage=Unable to submit your changes for review, please use the contact link to let us know you are having trouble.';
};
