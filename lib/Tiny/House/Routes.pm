use Dancer ':syntax';
use Dancer::Plugin::Database;
use Dancer::Plugin::Passphrase;

use Data::Entropy::Algorithms qw/rand_bits/;
use JSON;
use MIME::Base64 qw/encode_base64url/;
use MIME::Entity;
use Net::AWS::SES;

use Data::Dumper;

our $VERSION = '0.1';

get '/' => sub {
	template 'index' => {alert => {success => params->{'alertSuccess'}, message => params->{'alertMessage'}}};
};

post '/check_email_address' => sub {
	my $valid = database->quick_count('users', {email => params->{'email'}}) ? JSON::false : JSON::true; 

	return to_json {'valid' => $valid}
};

get '/change_password/:email/:token' => sub {
	template 'change_password' => {email => params->{'email'}, token => params->{'token'}};
};

post '/change_password' => sub {
	my $valid = database->quick_count('users', {email => params->{'email'}, token => params->{'token'}});

	if ($valid)
	{
		my $phrase = passphrase(params->{'password'})->generate;
	
		if (database->quick_update('users', {email => params->{'email'}, token => params->{'token'}}, {password => $phrase->rfc2307(), token => ''}))
		{
			return redirect '/?alertSuccess=1&alertMessage=Your password has been changed.';
		}
	}

	return redirect '/?alertSuccess=0&alertMessage=You have an incorrect token or email address specified. Please request to change your password again so we can send you the correct information.';
};

get '/register' => sub {
	template 'register';
};

post '/register' => sub {
	my $available = database->quick_count('users', {email => params->{'email'}}) ? undef : 1; 

	if ($available)
	{
		my $token = encode_base64url(rand_bits(192));

		database->quick_insert('users', {name => params->{'name'}, email => params->{'email'}, token => $token});

		my $link = request->uri_base() . "/change_password/" . params->{'email'} . "/" . $token;

		# Send Email here
                my $email_message = MIME::Entity->build
		(
			From => 'noreply@tiny.house',
			To => params->{'email'},
			Subject => 'Tiny.House - Confirm your email address',
			Data => 'To confirm your email address please visit <a href="' . $link . '">' . $link . '</a>',
			Type    => 'text/html',
		);

		my $ses = Net::AWS::SES->new(access_key => config->{aws_access_key_id}, secret_key => config->{aws_secret_access_key}); 
		my $response = $ses->send($email_message);

		if ($response->is_success) 
		{
			return redirect '/?alertSuccess=1&alertMessage=An email has been sent containing a link to set your password.';	
		}
		else
		{
			debug "\n\nCould not deliver the message: " . $response->error_message . "\n\n";
			return redirect '/?alertSuccess=0&alertMessage=Unable to send you an email to set your password, please try again later.';	
		}
	}
	else
	{
		return redirect '/?alertSuccess=0&alertMessage=' . params->{'email'} . ' is already registered.';	
	}
};

get '/login' => sub {
	template 'login';
};

post '/login' => sub {
	my $user = database->quick_select('users', {email => params->{'email'}});

	if ($user && params->{'password'} && $user->{'password'} && passphrase(params->{'password'})->matches($user->{'password'})) 
	{
		session user_name => $user->{'name'};
		session user_email => $user->{'email'};
		session user_id => $user->{'id'};

		# This is required by D::P::A::E
		session logged_in_user => $user->{'email'};
		session logged_in_user_realm => 'users';
		
		# Save which roles our use has for display differences
		session manage_roles => user_has_role('manage_roles');
		session manage_users => user_has_role('manage_users');
		session manage_places => user_has_role('manage_places');

		return redirect '/?alertSuccess=1&alertMessage=Welcome ' . $user->{'name'} . '.'; 
	}

	return redirect '/?alertSuccess=0&alertMessage=Incorrect email or password.'; 
};

get '/logout' => sub {
	session->destroy;

	return redirect '/?alertSuccess=1&alertMessage=You have been logged out.';
};

get '/reset_password' => sub {
	template 'reset_password';
};

post '/reset_password' => sub {

	my $exists = database->quick_count('users', {email => params->{'email'}}); 

	if ($exists)
	{
		my $token = encode_base64url(rand_bits(192));

		database->quick_update('users', {email => params->{'email'}}, {token => $token});

		my $link = request->uri_base() . "/change_password/" . params->{'email'} . "/" . $token;

		# Send Email here
                my $email_message = MIME::Entity->build
		(
			From => 'noreply@tiny.house',
			To => params->{'email'},
			Subject => 'Tiny.House - Reset your password',
			Data => 'To reset your password please visit <a href="' . $link . '">' . $link . '</a>',
			Type    => 'text/html',
		);

		my $ses = Net::AWS::SES->new(access_key => config->{aws_access_key_id}, secret_key => config->{aws_secret_access_key}); 
		my $response = $ses->send($email_message);

		if ($response->is_success) 
		{
			return redirect '/?alertSuccess=1&alertMessage=An email has been sent containing a link to reset your password.';	
		}
		else
		{
			debug "\n\nCould not deliver the message: " . $response->error_message . "\n\n";
			return redirect '/?alertSuccess=0&alertMessage=Unable to send you an email to reset your password, please try again later.';	
		}
	}
};

get '/denied' => sub {
	template 'index' => {alert => {success => 0, message => 'You do not have permission to access that page.'}};
}; 
