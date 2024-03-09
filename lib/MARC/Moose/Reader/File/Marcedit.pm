package MARC::Moose::Reader::File::Marcedit;
# ABSTRACT: File reader for MARC::Moose record from Marcedit file (.mrk)

use Moose;
use Modern::Perl;
use MARC::Moose::Record;
use MARC::Moose::Parser::Marcedit;

with 'MARC::Moose::Reader::File';


has '+parser' => (
    default => sub {
        my $parser = MARC::Moose::Parser::Marcedit->new();
        return $parser;
    }
);


sub read {
    my $self = shift;

    $self->count( $self->count + 1);

    my $fh = $self->{fh};

    return if eof($fh);

    my @lines;
    while (<$fh>) {
        s/\n$//;
        s/\r$//;
        last unless $_; # Ligne vide
        push @lines, $_;
    }

    $self->parser->parse(join("\n", @lines));
}


__PACKAGE__->meta->make_immutable;

1;

