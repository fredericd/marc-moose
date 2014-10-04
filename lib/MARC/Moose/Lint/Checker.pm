package MARC::Moose::Lint::Checker;
# ABSTRACT: A base-class to 'lint' biblio record

use Moose;
use Modern::Perl;
use YAML;


=method check( I<record> )

This method checks a biblio record, based on the current 'lint' object. The
biblio record is a L<MARC::Moose::Record> object. An array of validation
errors/warnings is returned. Those errors are just plain text explanation on
the reasons why the record doesn't comply with validation rules.

=cut
sub check {
    my ($self, $record) = @_;
    return ();
}


__PACKAGE__->meta->make_immutable;

1;

=head1 DESCRIPTION

A MARC biblio record, MARC21, UNIMARC, whatever, can be validated against
rules. By extending this class, you defines your own validation rules.

=head1 SEE ALSO

=for :list
* L<MARC::Moose>
* L<MARC::Moose::Lint::Checker::RulesFile>
* L<MARC::Moose::Lint::Processor>

