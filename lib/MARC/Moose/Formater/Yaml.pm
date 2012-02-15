package MARC::Moose::Formater::Yaml;
# ABSTRACT: Marc record formater into YAML representation

use Moose;

extends 'MARC::Moose::Formater';

use MARC::Moose::Field::Control;
use MARC::Moose::Field::Std;
use YAML::Syck;

$YAML::Syck::ImplicitUnicode = 1;


override 'format' => sub {
    my ($self, $record) = @_;

    return Dump($record);
};

__PACKAGE__->meta->make_immutable;

1;
