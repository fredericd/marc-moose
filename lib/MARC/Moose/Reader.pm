package MARC::Moose::Reader;
# ABSTRACT: Base class for a reader returning MARC::Moose records

use Moose::Role;

with 'MooseX::RW::Reader';



=attr parser

L<MARC::Moose::Parser> parser used to parse record that have been read.

=cut

has parser => (
    is => 'rw', isa => 'MARC::Moose::Parser',
);


1;

