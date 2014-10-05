package MARC::Moose::Parser::Json;
# ABSTRACT: Parser for JSON records

use Moose;
extends 'MARC::Moose::Parser';
use JSON;


override 'parse' => sub {
    my ($self, $raw) = @_;
    return unless $raw;
    my $json = from_json($raw);
    my @jfields = @{$json->{fields}};
    my @fields;
    while ( @jfields ) {
        my $tag = shift @jfields;
        my $value = shift @jfields;
        if ( ref($value) eq 'HASH' ) {
            my @subf;
            my @jsubf = @{$value->{subfields}};
            while (@jsubf) {
                my ($letter, $value) = (shift @jsubf, shift @jsubf);
                push @subf, [ $letter => $value ];
            }
            push @fields, MARC::Moose::Field::Std->new(
                tag => $tag,
                ind1 => $value->{ind1},
                ind2 => $value->{ind2},
                subf => \@subf );
        }
        else {
            push @fields, MARC::Moose::Field::Control->new(
                tag => $tag, value => $value );
        }
    }
    my $record = MARC::Moose::Record->new(
        leader => $json->{leader},
        fields => \@fields );
    $record->lint($self->lint) if $record->lint;
    return $record;
};

__PACKAGE__->meta->make_immutable;
1;

=head1 SEE ALSO
=for :list
* L<MARC::Moose>
* L<MARC::Moose::Parser>
