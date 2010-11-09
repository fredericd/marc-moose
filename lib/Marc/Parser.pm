package Marc::Parser;
# ABSTRACT: A Marc record parser base class

use namespace::autoclean;
use Moose;


# FIXME Experimental. Not used yet.
#has converter => (
#    is      => 'rw',
#    isa     => 'Text::IconvPtr',
#    default => sub { Text::Iconv->new( "cp857", "utf8" ) }
#);


sub begin {
    return "";
}


sub end {
    return "";
}


sub parse {
    return Marc::Record->new();
};

__PACKAGE__->meta->make_immutable;

1;

=method begin

=method end

=method parse

Return a Marc::Record object build from a parsed string

=head1 SEE ALSO

=for :list
* L<Marc>
* L<Marc::Parser::Iso2709>
* L<Marc::Parser::Marcxml>
* L<Marc::Parser::Isis>
