package MARC::Moose::Record;
# ABSTRACT: MARC::Moose bibliographic record

use namespace::autoclean;
use Moose;

use Carp;
use MARC::Moose::Formater::Iso2709;
use MARC::Moose::Formater::Json;
use MARC::Moose::Formater::Legacy;
use MARC::Moose::Formater::Marcxml;
use MARC::Moose::Formater::Text;
use MARC::Moose::Formater::Yaml;
use MARC::Moose::Parser::Iso2709;
use MARC::Moose::Parser::MarcxmlSax;
use MARC::Moose::Parser::Legacy;
use MARC::Moose::Parser::Yaml;


has leader => (
    is      => 'ro', 
    isa     => 'Str',
    writer  => '_leader',
    default => ' ' x 24,
);

has fields => ( 
    is => 'rw', 
    isa => 'ArrayRef', 
    default => sub { [] } 
);


# Global

# Les formater standards
my $formater = {
    iso2709 => MARC::Moose::Formater::Iso2709->new(),
    json    => MARC::Moose::Formater::Json->new(),
    legacy  => MARC::Moose::Formater::Legacy->new(),
    marcxml => MARC::Moose::Formater::Marcxml->new(),
    text    => MARC::Moose::Formater::Text->new(),
    yaml    => MARC::Moose::Formater::Yaml->new(),
};

# Les parser standards
my $parser = {
    iso2709 => MARC::Moose::Parser::Iso2709->new(),
    marcxml => MARC::Moose::Parser::MarcxmlSax->new(),
    legacy  => MARC::Moose::Parser::Legacy->new(),
    yaml    => MARC::Moose::Parser::Yaml->new(),
};


sub set_leader_length {
    my ($self, $length, $offset) = @_;

    carp "Record length of $length is larger than the MARC spec allows 99999"
        if $length > 99999;

    my $leader = $self->leader;
    substr($leader, 0, 5)  = sprintf("%05d", $length);
    substr($leader, 12, 5) = sprintf("%05d", $offset);

    # Default leader various pseudo variable fields
    # Force UNICODE MARC21: substr($leader, 9, 1) = 'a';
    substr($leader, 10, 2) = '22';
    substr($leader, 20, 4) = '4500';

    $self->_leader( $leader );
}


sub append {
    my ($self, $field_to_add) = @_;

    # Control field correctness
    carp  "Append a non MARC::Moose::Field"
        unless ref($field_to_add) =~ /^MARC::Moose::Field/; 

    my $tag = $field_to_add->tag;
    my @sf;
    for my $field ( @{$self->fields} ) {
        if ( $field_to_add and $field->tag gt $tag ) {
            push @sf, $field_to_add;
            $field_to_add = undef;
        }
        push @sf, $field;
    }
    push @sf, $field_to_add if $field_to_add;
    $self->fields( \@sf );
}


my %_field_regex;

sub field {
    my $self = shift;
    my @specs = @_;  

    my @list;
    for my $tag ( @specs ) {
        my $regex = $_field_regex{ $tag };
        # Compile & stash it if necessary
        unless ( $regex ) {
            $regex = qr/^$tag$/;
            $_field_regex{ $tag } = $regex;
        }
        for my $field ( @{$self->fields} ) {
            if ( $field->tag =~ $regex ) {
                return $field unless wantarray;
                push @list, $field;
            }
        }
    }
    wantarray
        ? @list
        : @list ? $list[0] : undef;
}


sub as {
    my ($self, $format) = @_;
    my $f = $formater->{ lc($format) };
    return $f ? $f->format($self) : undef;
}


sub new_from {
    my ($record, $type) = @_;
    my $p = $parser->{ lc($type) };
    $p ? $p->parse($record) : undef;
}


sub check {
    my $self = shift;

    for my $field ( @{$self->fields} ) {
        for my $subf ( @{$field->subf} ) {
            if ( @$subf != 2 ) {
                print "NON !!!\n";
                exit;
            }
        }
    }
}


__PACKAGE__->meta->make_immutable;

1;


=head1 SYNOPSYS

 use MARC::Moose::Record;
 use MARC::Moose::Field::Control;
 use MARC::Moose::Field::Std;
 use MARC::Moose::Formater::Text;
 
 my $record = MARC::Moose::Record->new(
     fields => [
         MARC::Moose::Field::Control->new(
             tag => '001',
             value => '1234' ),
         MARC::Moose::Field::Std->new(
             tag => '245',
             subf => [ [ a => 'MARC is dying for ever:' ], [ b => 'will it ever happen?' ] ] ),
         MARC::Moose::Field::Std->new(
             tag => '260',
             subf => [
                 [ a => 'Paris:' ],
                 [ b => 'Usefull Press,' ],
                 [ c => '2010.' ],
             ] ),
         MARC::Moose::Field::Std->new(
             tag => '600',
             subf => [ [ a => 'Library' ], [ b => 'Standards' ] ] ),
         MARC::Moose::Field::Std->new(
             tag => '900',
             subf => [ [ a => 'My local field 1' ] ] ),
         MARC::Moose::Field::Std->new(
             tag => '901',
             subf => [ [ a => 'My local field 1' ] ] ),
     ]
 );
   
 my $formater = MARC::Moose::Formater::Text->new();
 print $formater->format( $record );
 
 $record->fields( [ grep { $_->tag < 900 } @{$record->fields} ] );
 print "After local fields removing:\n", $formater->format($record);

=head1 DESCRIPTION

MARC::Moose::Record is an object, Moose based object, representing a MARC::Moose
bibliographic record. It can be a MARC21, UNIMARC, or whatever biblio record.

=attr leader

Read-only string. The leader is fixed by set_leader_length method.

=attr fields

ArrayRef on MARC::Moose::Field objects: MARC::Moose:Fields::Control and
MARC::Moose::Field::Std.

=method append( I<field> )

Append a MARC::Moose::Field in the record. The record is appended at the end of
numerical section, ie if you append for example a 710 field, it will be placed
at the end of the 7xx fields section, just before 8xx section or at the end of
fields list.

 $record->append(
   MARC::Moose::Field::Std->new(
    tag  => '100',
    subf => [ [ a => 'Poe, Edgar Allan' ],
              [ u => 'Translation' ] ]
 ) );

=method field( I<tag> )

Returns a list of tags that match the field specifier, or an empty list if
nothing matched.  In scalar context, returns the first matching tag, or undef
if nothing matched.
         
The field specifier can be a simple number (i.e. "245"), or use the "."
notation of wildcarding (i.e. subject tags are "6.."). All fields are returned
if "..." is specified.

=method as( I<format> )

Returns a formated version of the record as defined by I<format>. Format are standard
formater provided by the MARC::Moose::Record package: Iso2709, Text, Marcxml,
Json, Yaml, Legacy.

=method set_leader_length( I<length>, I<offset> )

This method is called to reset leader length of record and offset of data
section. This means something only for ISO2709 formated records. So this method
is exlusively called by any formater which has to build a valid ISO2709 data
stream. It also forces leader position 10 and 20-23 since this variable values
aren't variable at all for any ordinary MARC record.

Called by L<MARC::Moose::Formater::Iso2709>.

 $record->set_leader_length( $length, $offset );

=head1 SEE ALSO

=for :list
* L<MARC::Moose>
* L<MARC::Moose::Field>
