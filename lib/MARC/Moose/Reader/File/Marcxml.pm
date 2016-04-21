package MARC::Moose::Reader::File::Marcxml;
# ABSTRACT: File reader for MARCXML file

use Moose;

use Carp;
use MARC::Moose::Record;
use MARC::Moose::Parser::Marcxml;

with 'MARC::Moose::Reader::File';


=attr parser

By default, a L<MARC::Moose::Parser::MarcxmlSax> parser is used.

=cut

has '+parser' => ( default => sub { MARC::Moose::Parser::MarcxmlSax->new() } );


sub read {
    my $self = shift;

    $self->count($self->count + 1);

    my $fh = $self->{fh};

    return if eof($fh);

    local $/ = "</record>"; # End of record
    my $raw = <$fh>;
    
    # Skip <collection if present
    $raw =~ s/<(\/*)collection.*>//;

    # End of file
    return unless $raw =~ /<record.*>/;

    $self->parser->parse( $raw );
}

__PACKAGE__->meta->make_immutable;

1;


=head1 DESCRIPTION

Override L<MARC::Moose::Reader::File>, and read a file containing MARCXML
records.

=cut

