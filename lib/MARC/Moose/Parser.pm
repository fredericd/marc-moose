package MARC::Moose::Parser;
# ABSTRACT: A record parser base class

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
    return MARC::Moose::Record->new();
};

__PACKAGE__->meta->make_immutable;

1;

=method begin

=method end

=method parse

Return a MARC::Moose::Record object build from a parsed string

=head1 SEE ALSO

=for :list
* L<MARC::Moose>
* L<MARC::Moose::Parser::Iso2709>
* L<MARC::Moose::Parser::MARC::Moosexml>
* L<MARC::Moose::Parser::Isis>
