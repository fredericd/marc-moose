package MARC::Moose::Reader::File;
# ABSTRACT: A Moose::Role MARC::Moose::Record reader from a file

use Moose::Role;

with 'MARC::Moose::Reader',
     'MooseX::RW::Reader::File';


1;

=head1 SEE ALSO

=for :list
* L<MARC::Moose>
* L<MARC::Moose::Reader>
