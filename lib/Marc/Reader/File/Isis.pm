package Marc::Reader::File::Isis;
# ABSTRACT: Marc file reader for ISIS (DOS) encoded records

use namespace::autoclean;
use Moose;

use Carp;
use Marc::Record;
use Marc::Parser::Isis;

extends 'Marc::Reader::File';


has parser => ( 
    is => 'rw', 
    isa => 'Marc::Parser',
    default => sub { Marc::Parser::Isis->new() },
);


override 'read' => sub {
    my $self = shift;

    $self->SUPER::read();

    my $fh = $self->fh;
    my $raw;
    while ( <$fh> ) {
        s/\x0a|\x0d//g;
        $raw .= $_;
        last if /\x1d/; # End of record separator
    }
    return 0 unless $raw;

    return $self->parser->parse( $raw );
};

__PACKAGE__->meta->make_immutable;

1;

=method read

Read next available L<Marc::Record> from reader file using
L<Marc::Parser::Isis> parser.

=head1 SEE ALSO

=for :list
* L<Marc>
* L<Marc::Reader::File>
* L<Marc::Parser::Isis>
