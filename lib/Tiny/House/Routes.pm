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

post '/change_password/:email/:token' => sub {
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

		database->quick_insert('users', {name => params->{'email'}, email => params->{'email'}, token => $token});

		my $link = request->uri_base() . "/change_password/" . params->{'email'} . "/" . $token;

		# Send Email here XXX TODO
                my $email_message = MIME::Entity->build
		(
			From => 'noreply@Tiny.House',
			To => params->{'email'},
			Subject => 'Tiny.House - Confirm your email address',
			Data => 'To confirm your email address please visit <a href="' . $link . '">' . $link . '</a>',
		);

		my $ses = Net::AWS::SES->new(access_key => config->{aws_access_key_id}, secret_key => config->{aws_secret_access_key}); 
		my $response = $ses->send($email_message);

		if ($response->is_success) 
		{
			return redirect '/?alertSuccess=1&alertMessage=An email has been sent containing a link to set your password.';	
		}
		else
		{
			return redirect '/?alertSuccess=0&alertMessage=Unable to send you an email to set your password, please try again later.';	
			debug "\n\nCould not deliver the message: " . $response->error_message . "\n\n";
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

	if ($user && passphrase(params->{'password'})->matches($user->{'password'})) 
	{
		session user_name => $user->{'name'};
		session user_email => $user->{'email'};
		session user_id => $user->{'id'};

		# This is required by D::P::A::E
		session logged_in_user => $user->{'email'};

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

		database->quick_update('users', {name => params->{'email'}, email => params->{'email'}}, {token => $token});

		debug "\n\nREGISTER: http://192.168.1.2:3000/change_password/" . params->{'email'} . "/$token\n\n";

		# Send Email here XXX TODO

	}

	return redirect '/?alertSuccess=1&alertMessage=An email has been sent containing a link to reset your password.';	

};

get '/resources/land' => sub {
	my @places = database->quick_select('places', {}, {order_by => ['state', 'place']});

	template 'resources/land', {places => \@places};
};
