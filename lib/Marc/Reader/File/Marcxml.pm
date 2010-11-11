package Marc::Reader::File::Marcxml;
# ABSTRACT: File reader for Marc record from MARCXML file

use namespace::autoclean;
use Moose;

use Carp;
use Marc::Record;
use Marc::Parser::Marcxml;

extends 'Marc::Reader::File';


has parser => ( 
    is => 'rw', 
    isa => 'Marc::Parser',
    default => sub { Marc::Parser::Marcxml->new() },
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

    return $self->parser->parse( $raw );
};

__PACKAGE__->meta->make_immutable;

1;

