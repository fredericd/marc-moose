package MARC::Moose::Lint::Checker;
# ABSTRACT: A Moose::Role to 'lint' biblio record

use Moose::Role;


=method check( I<record> )

This method checks a biblio record, based on the current 'lint' object. The
biblio record is a L<MARC::Moose::Record> object. An array of validation
errors/warnings is returned. Those errors are just plain text explanation on
the reasons why the record doesn't comply with validation rules. This role
could be applied directly to a L<MARC::Moose::Record> object or to
L<MARC::Moose::Reader> object.

=cut
sub check {
    my ($self, $record) = @_;
    return ();
}


1;

=head1 DESCRIPTION

A MARC biblio record, MARC21, UNIMARC, whatever, can be validated against
rules. By extending this class, you defines your own validation rules. Then the
'lint' object can be given to a L<MARC::Moose::Record> or a
L<MARC::Moose::Reader>

=head1 SYNOPSYS

 package LintPPN;

 use Moose;
 with 'MARC::Moose::Lint::Checker'

 sub check {
     my ($self, $record) = @_;
     my @warnings = ();
     if ( my $ppn = $record->field('001') ) {
        if ( $ppn->value !~ /^PPN[0-9]*$/ ) {
            push @warning, "Invalid PPN in 001 field";
        }
     }
     else {
        push @warning, "No 001 field";
     }
     return @warnings;
 }

 package Main;

 use MARC::Moose::Reader::File::Iso2709;
 use MARC::Moose::Parser::Iso2709;

 # Dump as text all biblio records without valid PPN
 my $reader = $MARC::Moose::Reader::File::Iso2709(
    file => 'biblio.mrc',
    parser => MARC::Moose::Parser::Iso2709->new( lint => LintPPN->new() ));
 while ( my $record = $reader->read() ) {
    if ( my @warnings = $record->check() ) {
        say $record->as('Text');
    }
 }

=head1 SEE ALSO

=for :list
* L<MARC::Moose>
* L<MARC::Moose::Lint::Checker::RulesFile>
* L<MARC::Moose::Lint::Processor>

