package MARC::Moose::Formater::Iso2709;
# ABSTRACT: MARC::Moose record formater into ISO 2709 format

use namespace::autoclean;
use Moose;
use 5.010;
use utf8;

extends 'MARC::Moose::Formater';

use MARC::Moose::Field::Control;
use MARC::Moose::Field::Std;



override 'format' => sub {
    my ($self, $record) = @_;

    my ( $directory, $fields, $from ) = ( '', '', 0 );
    use YAML;
    for my $field ( @{$record->fields} ) {
        my $str = do {
            if ( ref($field) eq 'MARC::Moose::Field::Control' ) {
                $field->value . "\x1E";
            }
            else {
                my $str = '';
                $str .= "\x1F" . $_->[0] . $_->[1]  for @{$field->subf};
                $str = $field->ind1 . $field->ind2 . $str . "\x1E";
            }
        };
        $fields .= $str;
        #FIXME: Which of this lines is the correct one?
        my $len = bytes::length($str);
        #my $len = length($str);
        $directory .= sprintf( "%03s%04d%05d", $field->tag, $len, $from );
        $from += $len;
    }

    # Update leader with calculated offset (data begining) and total length of
    # record
    my $offset = 24 + 12 * @{$record->fields} + 1;
    my $length = $offset + $from + 1;
    $record->set_leader_length( $length, $offset );

    return $record->leader . $directory . "\x1E" . $fields . "\x1D";
};

__PACKAGE__->meta->make_immutable;

1;

