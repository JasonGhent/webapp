package Tiny::House;
use Dancer ':syntax';

use Data::Dumper;

our $VERSION = '0.1';

get '/' => sub {
  template 'index';
};

post '/register' => sub {
  return to_json { message => "Registered" }
};
  
true;
