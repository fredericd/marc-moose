package Marc::Parser;

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

