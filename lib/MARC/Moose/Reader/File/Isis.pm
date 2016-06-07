package MARC::Moose::Reader::File::Isis;
# ABSTRACT: A file reader for ISIS (DOS) encoded records

use Moose;

use Carp;
use MARC::Moose::Record;
use MARC::Moose::Parser::Isis;

with 'MARC::Moose::Reader::File';


=attr parser

By default, use L<MARC::Moose::Parser::Isis> to read L<MARC::Moose::Record>
records from a file.

has '+parser' => ( default => sub { MARC::Moose::Parser::Isis->new() } );

=cut

has '+parser' => ( default => sub { MARC::Moose::Parser::Isis->new() } );


sub read {
    my $self = shift;

    $self->count( $self->count + 1 );

    my $fh = $self->fh;
    my $raw;
    while ( <$fh> ) {
        s/\x0a|\x0d//g;
        $raw .= $_;
        last if /\x1d/; # End of record separator
    }
    return 0 unless $raw;

    return $self->parser->parse( $raw );
}

__PACKAGE__->meta->make_immutable;

1;

=head1 DESCRIPTION

Read next available L<MARC::Moose::Record> from reader file using
L<MARC::Moose::Parser::Isis> parser.

=head1 SEE ALSO

=for :list
* L<MARC::Moose>
* L<MARC::Moose::Reader::File>
* L<MARC::Moose::Parser::Isis>
