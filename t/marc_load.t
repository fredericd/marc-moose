#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 16;
BEGIN {
    use FindBin qw( $Bin );
    use lib "$Bin/../lib";
    use_ok( 'Marc::Record' );
    use_ok( 'Marc::Field' );
    use_ok( 'Marc::Field::Std' );
    use_ok( 'Marc::Field::Control' );
    use_ok( 'Marc::Parser' );
    use_ok( 'Marc::Parser::Iso2709' );
    use_ok( 'Marc::Formater' );
    use_ok( 'Marc::Formater::Iso2709' );
    use_ok( 'Marc::Formater::Marcxml' );
    use_ok( 'Marc::Formater::Yaml' );
    use_ok( 'Marc::Formater::Text' );
    use_ok( 'Marc::Reader' );
    use_ok( 'Marc::Reader::File' );
    use_ok( 'Marc::Reader::File::Iso2709' );
    use_ok( 'Marc::Writer' );
    use_ok( 'Marc::Writer::File' );
}
