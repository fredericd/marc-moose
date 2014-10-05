package MARC::Moose::Reader;
# ABSTRACT: Base class for a reader returning MARC::Moose records

use Moose::Role;
use MARC::Moose::Lint::Checker;

with 'MooseX::RW::Reader';



=attr parser

L<MARC::Moose::Parser> parser used to parse record that have been read.

=cut

has parser => (
    is => 'rw', isa => 'MARC::Moose::Parser',
);


has lint => (
    is => 'rw',
    isa => 'MARC::Moose::Lint::Checker',
    #defaut => sub { MARC::Moose::Lint::Checker->new(); },
);





1;

