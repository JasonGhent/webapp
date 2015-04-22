use Dancer ':syntax';
use Dancer::Plugin::Database;

our $VERSION = '0.1';

prefix '/resources/faq';

get '/' => sub {
	template 'resources/faq';
};
