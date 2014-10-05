package MARC::Moose::Reader;
# ABSTRACT: Base class for a reader returning MARC::Moose records

use Moose::Role;
use MARC::Moose::Lint::Checker;

with 'MooseX::RW::Reader';



=attr parser

L<MARC::Moose::Parser> parser used to parse records that have been read.

=cut

has parser => (
    is => 'rw', isa => 'MARC::Moose::Parser',
);



1;

