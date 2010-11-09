package Marc::Parser::Iso2709;

use namespace::autoclean;
use Moose;

extends 'Marc::Parser';

use Marc::Field::Control;
use Marc::Field::Std;


# FIXME Experimental. Not used yet.
#has converter => (
#    is      => 'rw',
#    isa     => 'Text::IconvPtr',
#    default => sub { Text::Iconv->new( "cp857", "utf8" ) }
#);



override 'parse' => sub {
    my ($self, $raw) = @_;

    #print "\nRAW: $raw\n";

    return unless $raw;

    my $record = Marc::Record->new();

    my $leader = substr($raw, 0, 24);
    #print "leader: $leader\n";
    $record->_leader( $leader );

    $raw = substr($raw, 24);
    my $end_directory = index $raw, "\x1e";
    my $directory = substr $raw, 0, $end_directory;
    my $content = substr($raw, $end_directory + 1);
    my $number_of_tag = length($directory) / 12; 
    my @fields;
    for (my $i = 0; $i < $number_of_tag; $i++) {
        my $off = $i * 12;
        my $tag = substr($directory, $off, 3);
        my $len = substr($directory, $off+3, 4) - 1;
        my $pos = substr($directory, $off+7, 5) + 0;
        next if $pos + $len > length($content);
        my $value = substr($content, $pos, $len);
        #$value = $self->converter->convert($value);
        if ( $value =~ /\x1F/ ) { # There are some letters
            my $i1 = substr($value, 0, 1);
            my $i2 = substr($value, 1, 1);
            $value = substr($value, 2);
            my @sf;
            for ( split /\x1F/, $value) {
                next if length($_) <= 2;                                 
                push @sf, [ substr($_, 0, 1), substr($_, 1) ];
            }
            push @fields, Marc::Field::Std->new(
                tag => $tag, ind1 => $i1, ind2 => $i2, subf => \@sf );
        }
        else {
            push @fields, Marc::Field::Control->new( tag => $tag, value => $value );
        }
    }
    $record->fields( \@fields );
    return $record;
};

__PACKAGE__->meta->make_immutable;

1;

