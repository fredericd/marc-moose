package Marc::Parser::Isis;
use Moose;

extends 'Marc::Parser';

use Carp;
use YAML;
use Text::Iconv 1.7;
use Marc::Record;
use Marc::Field::Std;
use Marc::Field::Control;


has fh => ( is => 'rw' );

has converter => (
    is      => 'rw',
    isa     => 'Text::IconvPtr',
    default => sub { Text::Iconv->new( "cp857", "utf8" ) }
);



override 'parse' => sub {
    my ($self, $raw) = @_;

    my $record = Marc::Record->new();

    my $leader = substr($raw, 0, 24);
    $record->_leader($leader);

    $raw = substr($raw, 24);
    my ($directory, $content) = $raw =~ /(.*?)\x1e(.*)$/;
    my $number_of_tag = length($directory) / 12;
    for (my $i = 0; $i < $number_of_tag; $i++) {
        my $off = $i * 12;
        my $tag = substr($directory, $off, 3);
        my $len = substr($directory, $off+3, 4) - 1;
        my $pos = substr($directory, $off+7, 5) + 0;
        next if $pos + $len > length($content);
        my $value = substr($content, $pos, $len);
        $value = $self->converter->convert($value);
        if ( $value =~ /\^/ ) { # There are some letters
            my $i1 = substr($value, 0, 1);
            my $i2 = substr($value, 1, 1);
            # We can have indicators inconsistencies, even no indicator at all,
            # even for a tag >= 010...
            if ( $i1 eq '^' ) {
                $i1 = $i1 = ' ';
            }
            elsif ( $i2 eq '^' ) {
                $i2 = ' ';
                $value = substr($value, 1);
            }
            else {
                $value = substr($value, 2);
            }
            my @sf;
            for ( split /\^/, $value) {
                next if length($_) <= 2;
                push @sf, [ substr($_, 0, 1), substr($_, 1) ];
            }
            $record->append( Marc::Field::Std->new(
                tag  => $tag,
                ind1 => $i1,
                ind2 => $i2,
                subf => \@sf
            ) ) if @sf;
        }
        else {
            # A field >= 010 can have no subfield. In this case, its value is
            # stored in a pseudo subfield $7
            $record->append(
                $tag + 0 < 10
                ? Marc::Field::Control->new( tag => $tag, value => $value ) 
                : Marc::Field::Std->new( tag => $tag, subf => [ [ Z => $value ] ]) );
        }
    }

    return $record;
};

__PACKAGE__->meta->make_immutable;

1;

=head1 COPYRIGHT AND LICENSE

Copyright 2010 by Tamil, s.a.r.l.

L<http://www.tamil.fr>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
