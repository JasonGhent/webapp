package Tiny::House;
use Dancer ':syntax';
use Dancer::Plugin::Database;
use Dancer::Plugin::Passphrase;

use Data::Entropy::Algorithms qw/rand_bits/;
use JSON;
use MIME::Base64 qw/encode_base64url/;

use Data::Dumper;

our $VERSION = '0.1';

get '/' => sub {
	template 'index' => {alert => {success => params->{'alertSuccess'}, message => params->{'alertMessage'}}};
};

post '/check_email_address' => sub {
	my $valid = database->quick_count('users', {email => params->{'registerEmail'}}) ? JSON::false : JSON::true; 

	return to_json {'valid' => $valid}
};

get '/change_password/:email/:token' => sub {
	template 'change_password' => {email => params->{'email'}, token => params->{'token'}};
};

post '/change_password' => sub {
	my $valid = database->quick_count('users', {email => params->{'changePasswordEmail'}, token => params->{'changePasswordToken'}});

	if ($valid)
	{
		my $phrase = passphrase(param(params->{'changePasswordPassword'}))->generate;
		
		database->quick_update('users', {email => params->{'changePasswordEmail'}, token => params->{'changePasswordToken'}}, {password => $phrase->rfc2307(), token => ''});

		return to_json {success => 1, message => "Your password has been changed."}
	}
	else
	{
		return to_json {success => 0, message => "You have an incorrect token or email address specified. Please request to change your password again so we can send you the correct information."}
	}
};

get '/register' => sub {
	template 'register';
};

post '/register' => sub {
	my $errors;

	my $available = database->quick_count('users', {email => params->{'registerEmail'}}) ? JSON::false : JSON::true; 

	if ($available)
	{
		my $token = encode_base64url(rand_bits(192));

		database->quick_insert('users', {name => params->{'registerName'}, email => params->{'registerEmail'}, token => $token});

		debug "\n\nToken: $token\n\n";

		# Send Email here XXX TODO

		return redirect '/?alertSuccess=1&alertMessage=An email has been sent container a link to set your password.';	

	}
	else
	{
		return redirect '/?alertSuccess=0&alertMessage=' . params->{'registerEmail'} . ' is already registered.';	
	}
};
