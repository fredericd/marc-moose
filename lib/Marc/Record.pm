package Marc::Record;
# ABSTRACT: Marc bibliographic record

use namespace::autoclean;
use Moose;

use Carp;


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
    carp  "Append a non Marc::Field"
        unless ref($field_to_add) =~ /^Marc::Field/; 

    my $tag_first = substr($field_to_add->tag, 0, 1);
    my @sf;
    for my $field ( @{$self->fields} ) {
        if ( $field_to_add and substr($field->tag, 0, 1) gt $tag_first ) {
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
    use YAML;
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
    return @list;
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

 use Marc::Record;
 use Marc::Reader::File;
 use Marc::Parser::Iso2709;
 use Marc::Formater::Text;

 my $reader = Marc::Reader::File->new(
     file   => 'biblio.iso',
     parser => Marc::Parser::Iso2709->new()
 );
 my $formater = Marc::Formater::Text->new();
 while ( my $record = $reader->read() ) {
     print $formater->format( $record );
 }

=head1 DESCRIPTION

Marc::Record is an object, Moose based object, representing a Marc
bibliographic record. It can be a MARC21, UNIMARC, or whatever biblio record.

=attr leader

Read-only string. The leader is fixed by set_leader_length method.

=attr fields

ArrayRef on Marc::Field objects: Marc:Fields::Control and Marc::Field::Std.

=method append( I<field> )

Append a Marc::Field in the record. The record is appended at the end of
numerical section, ie if you append for example a 710 field, it will be placed
at the end of the 7xx fields section, just before 8xx section or at the end of
fields list.

 $record->append(
   Marc::Field::Std->new(
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

=method set_leader_length( I<length>, I<offset> )

This method is called to reset leader length of record and offset of data
section. This means something only for ISO2709 formated records. So this method
is exlusively called by any formater which has to build a valid ISO2709 data
stream. It also forces leader position 10 and 20-23 since this variable values
aren't variable at all for any ordinary MARC record.

Called by Marc::Formater::Iso2709.

 $record->set_leader_length( $length, $offset );

=head1 SEE ALSO

=for :list

* L<Marc>
