use Dancer ':syntax';
use Dancer::Plugin::Database;

use File::Copy;

our $VERSION = '0.1';

prefix '/resources/land';

get '/' => sub {
	my $page = params->{'page'} || 1;
print STDERR "\n\n\nPAGE $page\n\n\n";

	my $sth = database->prepare("
SELECT id, place, state 
  FROM (
      SELECT p1.*
           , ROW_NUMBER() OVER (PARTITION BY id ORDER BY revision DESC) AS n
        FROM places      AS p1
       WHERE status = 'approved'
       ) AS vv
 WHERE n = 1
 order by state, place
");

	$sth->execute();

	my $places = $sth->fetchall_arrayref({});

	$sth = database->prepare("
SELECT 
	state, place
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
			status = 'approved'
	) 
	AND 
		status = 'review'
	 ");

	$sth->execute;

	my $places_awaiting_review = $sth->fetchall_arrayref({});
	my $awaiting_review = scalar(@{$places_awaiting_review}); 

	template 'resources/land', 
	{
		current_page => params->{'page'},
		entries_per_page => 10,
		places => $places,
		places_awaiting_review => $places_awaiting_review, 
		awaiting_review => $awaiting_review
	};
};

get '/view/:land' => sub {
	my $place = database->quick_select('places', {id => params->{'land'}, status => 'approved'}, {order_by => { desc => 'revision'}});
	
	template 'resources/land/view', {place => $place};
};

get '/edit/:land' => sub {
	my $place = database->quick_select('places', {id => params->{'land'}, status => 'approved'}, {order_by => {desc => 'revision'}});
	
	template 'resources/land/edit', {place => $place};
};

post '/edit/:id' => sub {
	my $place_id = params->{'place_id'};
	my $new_place_entry = {id => $place_id};
	my $new_file_entry = {place_id => $place_id};

	# See if we need to insert a new place or file
	my $new_place = undef;
	my $new_file = undef;

	# Copy over some things that need to stick with every record 
	my $row = database->quick_select('places', {id => $place_id, status => 'approved'}, {order_by => {desc => 'revision'}});
	$new_place_entry->{'kml'} = $row->{'kml'};
	$new_place_entry->{'created_by'} = session 'user_id';

	if (exists(params->{'place'}) && params->{'place'} ne $row->{'place'})
	{
		$new_place_entry->{'place'} = params->{'place'};
		$new_place = 1;
	}

	if (exists(params->{'state'}) && params->{'state'} ne $row->{'state'})
	{
		$new_place_entry->{'state'} = params->{'state'};
		$new_place = 1;
	}

	if (exists(params->{'adu'}) && params->{'adu'} =~ /^\d+$/ && params->{'adu'} ne $row->{'adu_minimum_square_feet'})
	{
		$new_place_entry->{'adu_minimum_square_feet'} = params->{'adu'};
		$new_place = 1;
	}

	if (exists(params->{'foundation'}) && params->{'foundation'} =~ /^\d+$/ && params->{'foundation'} ne $row->{'foundation_minimum_square_feet'})
	{
		$new_place_entry->{'foundation_minimum_square_feet'} = params->{'foundation'};
		$new_place = 1;
	}

	if (exists(params->{'mobile'}) && params->{'mobile'} =~ /^\d+$/ && params->{'mobile'} ne $row->{'trailer_minimum_square_feet'})
	{
		$new_place_entry->{'trailer_minimum_square_feet'} = params->{'mobile'};
		$new_place = 1;
	}

	if (exists(params->{'notes'}) && params->{'notes'} ne $row->{'notes'})
	{
		$new_place_entry->{'notes'} = params->{'notes'};
		$new_place = 1;
	}

	if (exists(params->{'button'}) && params->{'button'} eq 'approved')
	{
		# XXX TODO - need to deny everything older than us that isn't published when we do this
		$new_place_entry->{'status'} = 'approved';
		$new_place_entry->{'reviewed_by'} = session 'user_id';
	}
	else
	{
		$new_place_entry->{'status'} = 'review';
	}

	if (exists(params->{'upload_file'}))
	{
		my $file = request->upload('upload_file');
		my $name = params->{'upload_file'};


		# See if it's greater then 20 mb and ditch it
		if ($file->size > 20000000)
		{
			# XXX TODO - throw a warning about being too large
			unlink($file->tempname);
		}
	
		my $final_file = File::Temp->new(DIR => config->{'deploy_path'} . '/storage');

		if (!copy($file->tempname, $final_file))
		{
			# XXX TODO - throw a warning about the upload failing
		}
	
		$new_file_entry->{'name'} = $name;
		$new_file_entry->{'file_path'} = $final_file->filename;

		# status, created/moderated, 
	}

	database->{'AutoCommit'} = 0;
	database->{'RaiseError'} = 1;

	eval 
	{
		if ($new_place)
		{
			database->quick_insert('places', $new_place_entry);
		}

		if ($new_file)
		{
			database->quick_insert('attachments', $new_file_entry);
		}
	};

	if ($@)
	{
		eval { $dbh->rollback };

		return redirect '/?alertSuccess=0&alertMessage=Unable to submit your changes for review, please use the contact link to let us know you are having trouble.';
	}
	elsif ($new_place_entry->{'status'} eq 'review')
	{
		return redirect '/resources/land/view/' . $place_id . '?alertSuccess=1&alertMessage=Your changes have been submitted for review.';
	}
	else
	{
		return redirect '/resources/land/view/' . $place_id . '?alertSuccess=1&alertMessage=Your changes have been published.';
	}
};
