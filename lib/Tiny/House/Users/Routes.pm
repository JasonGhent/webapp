use Dancer ':syntax';
use Dancer::Plugin::Database;
use Dancer::Plugin::DBIC;
use Dancer::Plugin::Passphrase;

use Data::Entropy::Algorithms qw/rand_bits/;
use JSON;
use MIME::Base64 qw/encode_base64url/;

use Data::Dumper;

our $VERSION = '0.1';

prefix '/user';

get '/' => require_role manage_users => sub {
	my @users = schema->resultset('User')->all();

	template 'user/index', {users => \@users};
};

get '/view/:id' => require_role manage_users => sub {
	my $user = schema->resultset('User')->find({id => params->{'id'}});

	template '/user/view', {user => $user};
};

get '/edit' => sub {
	template 'user/index';
};

post '/edit' => sub {
	my $update_items;
	my $current_email = session->{'user_email'};
 
	my $current_user = schema->resultset('User')->find({email => $current_email});

	if (params->{'email'} && schema->resultset('User')->find({email => params->{'email'}}))
	{
		return redirect '/?alertSuccess=0&alertMessage=That email address is not available.';
	}

	$current_user->name(params->{'name'});
	$current_user->password(params->{'password'});
	$current_user->update; 
	
	return redirect '/user/?alertSuccess=1&alertMessage=Your account has been udpated.';
};
