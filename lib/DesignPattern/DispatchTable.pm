package DesignPattern::DispatchTable;

use warnings;
use strict;

=head1 NAME

DesignPattern::DispatchTable - Implementation of a reusable versatile dispatch table.

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

This module implements the DispatchTable design pattern, for code reuse,
readability, organisation, better coding style, and fun.

    use DesignPattern::DispatchTable;

    my $dispatch_table = DesignPattern::DispatchTable;
    $dispatch_table->register( $string     => $code_ref );
    $dispatch_table->register( qr{regexp?} => $code_ref );

    # Or even

    my $dispatch_table = DesignPattern::DispatchTable(
        $string     => $code_ref,
        qr{regexp?} => $code_ref
    );

    # and then you might call:
    $dispatch_table->call($argument);    # calls the first matching method

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 FUNCTIONS

=head2 new

Constructor. Returns a new Dispatch Table. Accepts an optional list of C<<
$condition => $code_ref >> pairs to be installed in the Dispatch Table.

=cut

sub new {
    my $class = shift;
    my $self = bless [], $class;
    eval { $self->register(@_) } if @_;
    die if $@;
    return $self;
}

=head2 register

Register accepts one or more pairs of C<< $condition => $code_ref >> and
install them in the Dispatch Table. Returns a true value if all values were
installed successfuly (i.e., there is no invalid values as key and all keys
have a proper code reference to go with it).

New versions of handlers (and corresponding decision code) are installed in the
beginining of the list. This makes for an implicit guarantee of reverse order:
I will always check first for the latest installed (decision, handlers) code
pairs.

=cut

# XXX: is there any sane way to check if a sub is already installed?
# XXX: is there any sane way to check if a Regexp is already installed?
# XXX: should I worry about duplicates?

sub register {
    my $self = shift;
    my @new_handlers;
    while ( my ( $decision, $handler ) = splice @_, 0, 2 ) {
        die q{Handler for decision "}
          . $decision
          . qq{" is not CODE. Did you pass less arguments than you should?\n}
          unless UNIVERSAL::isa( $handler, 'CODE' );
        return 0
          unless defined( ref $decision )
              || (   UNIVERSAL::isa( $decision, 'Regexp' )
                  || UNIVERSAL::isa( $decision, 'CODE' ) );
        push @new_handlers,
          {
            type => ref $decision || 'STRING',
            decision => $decision,
            handler  => $handler
          };
    }

    # Install new handlers in the begining of the list, prevents call() from
    # reaching the first version of duplicated methods.
    return unshift @$self, @new_handlers;
}

=head2 call

Call receives one or more values on which to make a decision about, and calls
the first matching decision on the values. If the decision was made with a
regular expression, it also arranges so the captured values are passed to the
code reference registered.

TODO: in case we allow passing in subroutines as decision making processes, we
should consider passing in the return value from the decision sub to the call
handler.

=cut

sub call {
    my ( $self,    $argument )  = @_;
    my ( $handler, @arguments ) = $self->code_for($argument);
    my $return_value = eval { $handler->(@arguments) };
    die qq{Error calling handler for $argument: $@} if $@;
    return $return_value;
}

=head2 code_for

Obtains the code for the given argument, and returns it. Used internally to
fetch the code handler bound to a specific (code|string|regex) in the dispatch
table.

=cut

sub code_for {
    my ( $self, $argument ) = @_;
    foreach my $entry (@$self) {
        my @results;

       # TODO: Find a way to implement this as a DesignPattern::DispatchTable :)
        if ( $entry->{type} eq 'STRING' && $entry->{decision} eq $argument ) {
            return $entry->{handler}, ();
        }
        elsif ( $entry->{type} eq 'Regexp'
            && ( @results = $argument =~ m{$$entry{decision}}ms ) )
        {
            return $entry->{handler}, @results;
        }
        elsif ($entry->{type} eq 'CODE'
            && ( @results = $entry->{handler}->($argument) )
            && @results )
        {
            return $entry->{handler}, @results;
        }
    }
}

=head1 AUTHOR

Luis Motta Campos, C<< <lmc at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-designpattern-dispatchtable at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=DesignPattern-DispatchTable>.  I will be notified, and then you'
          ll automatically be notified of progress on your bug as I make changes
          .

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc DesignPattern::DispatchTable


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=DesignPattern-DispatchTable>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/DesignPattern-DispatchTable>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/DesignPattern-DispatchTable>

=item * Search CPAN

L<http://search.cpan.org/dist/DesignPattern-DispatchTable/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2009 Luis Motta Campos, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1;    # End of DesignPattern::DispatchTable
