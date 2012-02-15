package MARC::Moose;
# ABSTRACT: Moose based MARC records set of tools

use Moose 1.00;

use Carp;


__PACKAGE__->meta->make_immutable;

1;

=head1 SYNOPSYS

 use MARC::Moose::Record;
 use MARC::Moose::Reader::File::Iso2709;

 my $reader = MARC::Moose::Reader::File::Iso2709->new(
     file   => 'biblio.iso', );
 while ( my $record = $reader->read() ) {
     # Remove some fields
     $record->fields([
         grep { not $_->tag ~~ [qw(001 009 039 917 930 955)] } @{$record->fields}
     ]);
     # Clean some subfields
     for my $field ( @{$record->fields} ) {
        next unless $field->tag ~~ [qw(410 461 600 606 607 608)];
        $field->subf([
          grep { not $_->[0] =~ /0|2|3|9/ } @{$field->subf}
        ]);
     }
     print $formater->format( $record );
 }

=head1 DESCRIPTION

=head1 WARNINGS

MARC records are expected to be UTF-8 encoded. It won't work if it isn't.
Parsed records MUST be UTF-8. If you don't have UTF-8 records, write a specific
reader or use a generic tool like yaz-marcdump before loading records.

=head1 SEE ALSO

=for :list
* L<MARC::Moose>
* L<MARC::Moose::Record>
* L<MARC::Moose::Field>
* L<MARC::Moose::Field::Std>
* L<MARC::Moose::Field::Control>
* L<MARC::Moose::Reader>
* L<MARC::Moose::Reader::File>
* L<MARC::Moose::Reader::File::Iso2709>
* L<MARC::Moose::Reader::File::Marcxml>
* L<MARC::Moose::Reader::File::Isis>
* L<MARC::Moose::Writer>
* L<MARC::Moose::Writer:File>
* L<MARC::Moose::Parser>
* L<MARC::Moose::Parser::Iso2709>
* L<MARC::Moose::Parser::Marcxml>
* L<MARC::Moose::Parser::MarcxmlSax>
* L<MARC::Moose::Parser::Isis>
* L<MARC::Moose::Formater>
* L<MARC::Moose::Formater::Iso2709>
* L<MARC::Moose::Formater::Marcxml>
* L<MARC::Moose::Formater::Text>
* L<MARC::Moose::Formater::Yaml>

