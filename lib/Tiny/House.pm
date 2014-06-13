package Tiny::House;
use Dancer ':syntax';
use Dancer::Plugin::Database;
use JSON;

use Data::Dumper;

our $VERSION = '0.1';

get '/' => sub {
	template 'index';
};

post '/check_email_address' => sub {
	my $valid = database->quick_count('users', {email => params->{email}}) ? JSON::false : JSON::true; 

	debug ("Valid: $valid");

	return to_json { 'valid' => $valid }
};

post '/register' => sub {
	return to_json { success => 1, message => "An email address has been sent to you containing a link to register." }
};
  
