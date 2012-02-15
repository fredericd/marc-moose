package MARC::Moose::Reader::String;
# ABSTRACT: A reader from a string

use Moose;

use Carp;
use MARC::Moose::Record;

extends 'MARC::Moose::Reader';

has string => ( is => 'rw', isa => 'Str' );


__PACKAGE__->meta->make_immutable;

1;

=attr string

The string containing the set of records to parser.

=head1 SEE ALSO

=for :list
* L<MARC::Moose>
* L<MARC::Moose::Reader>
* L<MARC::Moose::Reader::String::Iso2709>

