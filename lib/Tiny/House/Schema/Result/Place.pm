use utf8;
package Tiny::House::Schema::Result::Place;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Tiny::House::Schema::Result::Place

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=item * L<DBIx::Class::TimeStamp>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp");

=head1 TABLE: C<places>

=cut

__PACKAGE__->table("places");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'places_id_seq'

=head2 kml

  data_type: 'text'
  is_nullable: 0

=head2 place

  data_type: 'text'
  is_nullable: 0

=head2 revision

  data_type: 'timestamp'
  default_value: current_timestamp
  is_nullable: 0
  original: {default_value => \"now()"}

=head2 state

  data_type: 'text'
  is_nullable: 1

=head2 country

  data_type: 'text'
  is_nullable: 1

=head2 foundation_minimum_square_feet

  data_type: 'integer'
  is_nullable: 1

=head2 adu_minimum_square_feet

  data_type: 'integer'
  is_nullable: 1

=head2 rv_minimum_square_feet

  data_type: 'integer'
  is_nullable: 1

=head2 notes

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "places_id_seq",
  },
  "kml",
  { data_type => "text", is_nullable => 0 },
  "place",
  { data_type => "text", is_nullable => 0 },
  "revision",
  {
    data_type     => "timestamp",
    default_value => \"current_timestamp",
    is_nullable   => 0,
    original      => { default_value => \"now()" },
  },
  "state",
  { data_type => "text", is_nullable => 1 },
  "country",
  { data_type => "text", is_nullable => 1 },
  "foundation_minimum_square_feet",
  { data_type => "integer", is_nullable => 1 },
  "adu_minimum_square_feet",
  { data_type => "integer", is_nullable => 1 },
  "rv_minimum_square_feet",
  { data_type => "integer", is_nullable => 1 },
  "notes",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-04-22 10:53:43
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:YAkvW3IArcu286aAqugRLA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
