use Dancer ':syntax';
use Dancer::Plugin::Database;
use Dancer::Plugin::Passphrase;

use Data::Entropy::Algorithms qw/rand_bits/;
use JSON;
use MIME::Base64 qw/encode_base64url/;

use Data::Dumper;

our $VERSION = '0.1';

prefix '/user';

get '/' => require_role manage_users => sub {
	my @users = database->quick_select('users', {});

	template 'user/index', {users => \@users};
};

get '/view/:id' => require_role manage_users => sub {
	my $user = database->quick_select('users', {id => params->{'id'}});

	template '/user/view', {user => $user};
};

get '/edit' => sub {
	template 'user/index';
};

post '/edit' => sub {
	my $update_items;
	my $current_email = session->{'user_email'};
 
	if (params->{'email'})
	{
		# XXX TODO 
		# Should probably verify this is ok with the old email address
		# XXX TODO
		my $available = database->quick_count('users', {email => params->{'email'}}) ? undef : 1;

		if ($available)
		{ 
			$update_items->{'email'} = params->{'email'};
			session user_email => params->{'email'};
		}
		else
		{
			return redirect '/?alertSuccess=0&alertMessage=That email address is already in use.';
		}
	}

	if (params->{'name'})
	{
		$update_items->{'name'} = params->{'name'};
		session user_name => params->{'name'};
	}

	if (params->{'password'})
	{
		my $phrase = passphrase(params->{'password'})->generate;
	
		$update_items->{'password'} = $phrase->rfc2307();
	}

	if (scalar(keys(%{$update_items})) >= 1 && database->quick_update('users', {email => $current_email},  $update_items))
	{
		return redirect '/user/?alertSuccess=1&alertMessage=Your account has been udpated.';
	}

	return redirect '/?alertSuccess=0&alertMessage=Unable to update your account, please use the contact link to let us know you are having trouble.';
};
