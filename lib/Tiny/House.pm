package Tiny::House;
use Dancer ':syntax';
use Dancer::Plugin::Auth::Extensible;
use Dancer::Plugin::Database;
use Dancer::Plugin::Passphrase;

use Tiny::House::Routes;
use Tiny::House::Users::Routes;
use Tiny::House::Resources::Land::Routes;
use Tiny::House::Resources::FAQ::Routes;

use Data::Entropy::Algorithms qw/rand_bits/;
use JSON;
use MIME::Base64 qw/encode_base64url/;

use Data::Dumper;

our $VERSION = '0.1';

