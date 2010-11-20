package MARC::Moose::Parser::Marcxml;
# ABSTRACT: Parser for MARXML records

use namespace::autoclean;
use Moose;

extends 'MARC::Moose::Parser';

use MARC::Moose::Field::Control;
use MARC::Moose::Field::Std;


override 'parse' => sub {
    my ($self, $raw) = @_;

    return unless $raw;
    return undef unless $raw =~ /<record/;

    my @parts = split />/, $raw;
    my ($tag, $code, $ind1, $ind2);
    my $record = MARC::Moose::Record->new();
    my @fields;
    while ( @parts ) {
        $_ = shift @parts;
        $_ = shift @parts if /<record/;
        if ( /<leader/ ) {
            $_ = shift @parts;
            /(.*)<\/leader/;
            $record->_leader($1);
            next;
        }
        if ( /<controlfield\s*tag="(.*)"/ ) {
            my $tag = $1;
            $_ = shift @parts;
            s/<\/controlfield//;
            push @fields, MARC::Moose::Field::Control->new( tag => $tag, value => $_ );
            next;
        }
        if ( /<datafield\s*tag="(.*?)"\s*ind1="(.*?)"\s*ind2="(.*)"/ ) {
            my ($tag, $ind1, $ind2) = ($1, $2, $3);
            my @subf;
            while ( @parts && $parts[0] =~ /<subfield.*code="(.*)"/ ) {
                my $letter = $1;
                shift @parts;
                $_ = shift @parts;
                s/<\/subfield//;
                push @subf, [ $letter => $_ ];
            }
            push @fields, MARC::Moose::Field::Std->new(
                tag => $tag,
                ind1 => $ind1,
                ind2 => $ind2,
                subf => \@subf );
            shift @parts;
            next;
        }
        last;
    }
    $record->fields( \@fields );

    return $record;
};

__PACKAGE__->meta->make_immutable;

1;

=head1 DESCRIPTION

This MARCXML parser doesn't use a SAX parser. This results in better performances.

=head1 SEE ALSO

=for :list
* L<MARC::Moose>
* L<MARC::Moose::Parser>
