package MARC::Moose::Reader::File::Iso2709;
# ABSTRACT: File reader for MARC::Moose record from ISO2709 file

use namespace::autoclean;
use Moose;

use Carp;
use MARC::Moose::Record;
use MARC::Moose::Parser::Iso2709;

extends 'MARC::Moose::Reader::File';


has '+parser' => ( default => sub { MARC::Moose::Parser::Iso2709->new() } );


override 'read' => sub {
    my $self = shift;

    $self->SUPER::read();

    my $fh = $self->{fh};

    return if eof($fh);

    local $/ = "\x1D"; # End of record
    my $raw = <$fh>;

    # remove illegal garbage that sometimes occurs between records
    $raw =~ s/^[ \x00\x0a\x0d\x1a]+//;

    return $self->parser->parse( $raw );
};


__PACKAGE__->meta->make_immutable;

1;

