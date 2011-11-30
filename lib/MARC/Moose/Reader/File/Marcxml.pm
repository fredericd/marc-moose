package MARC::Moose::Reader::File::Marcxml;
# ABSTRACT: File reader for MARCXML file

use namespace::autoclean;
use Moose;

use Carp;
use MARC::Moose::Record;
use MARC::Moose::Parser::Marcxml;

extends 'MARC::Moose::Reader::File';


has parser => ( 
    is => 'rw', 
    isa => 'MARC::Moose::Parser',
    default => sub { MARC::Moose::Parser::Marcxml->new() },
);


override 'read' => sub {
    my $self = shift;

    $self->SUPER::read();

    my $fh = $self->{fh};

    return if eof($fh);

    local $/ = "</record>"; # End of record
    my $raw = <$fh>;
    
    # Skip <collection if present
    $raw =~ s/<(\/*)collection.*>//;

    # End of file
    return unless $raw =~ /<record>/;

    return $self->parser->parse( $raw );
};

__PACKAGE__->meta->make_immutable;

1;

