package MARC::Moose::Reader::String;
# ABSTRACT: A Moose::Role reader from a string

use Moose::Role;

with 'MARC::Moose::Reader';

has string => ( is => 'rw', isa => 'Str' );


1;

=attr string

The string containing the set of records to parser.

=head1 SEE ALSO

=for :list
* L<MARC::Moose>
* L<MARC::Moose::Reader>
* L<MARC::Moose::Reader::String::Iso2709>

