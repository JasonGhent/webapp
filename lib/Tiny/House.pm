package Tiny::House;
use Dancer ':syntax';

use Data::Dumper;

our $VERSION = '0.1';

get '/' => sub {
  template 'index';
};

post '/register' => sub {
  return to_json { success => 1, message => "An email address has been sent to you containing a link to register." }
};
  
true;
