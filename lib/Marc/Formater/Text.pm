package Marc::Formater::Text;
# ABSTRACT: Marc record formater into a text representation

use namespace::autoclean;
use Moose;

extends 'Marc::Formater';

use Marc::Field::Control;
use Marc::Field::Std;


override 'format' => sub {
    my ($self, $record) = @_;

    my $text = join "\n",
         $record->leader,
         map {
             $_->tag .
             ( ref($_) eq 'Marc::Field::Control' 
               ? $_->value
               : ' ' . $_->ind1 . $_->ind2 . ' '  .
               join ' ', map { ('$' . $_->[0], $_->[1] ) } @{$_->subf}
             );
         } @{ $record->fields };
    return $text . "\n\n"; 
};

__PACKAGE__->meta->make_immutable;

1;
