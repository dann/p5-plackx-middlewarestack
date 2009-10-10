package PlackX::MiddlewareStack;
use strict;
use warnings;
our $VERSION = '0.01';
use Tie::LLHash;

sub new {
    my $class       = shift;
    my %middlewares = ();
    tie( %middlewares, 'Tie::LLHash' );
    bless { middlewares => \%middlewares }, $class;
}

sub add {
    my ( $self, $mw_class, $args ) = @_;

    my $mw = $self->_to_middleware( $mw_class, $args );
    ( tied %{ $self->{middlewares} } )->last( $mw_class => $mw );
}

sub insert_after {
    my ( $self, $mw_class_to_add, $args, $target_mw_class ) = @_;

    my $mw = $self->_to_middleware( $mw_class_to_add, $args );
    ( tied %{ $self->{middlewares} } )
        ->insert( $mw_class_to_add => $mw, $target_mw_class );
}

sub insert_before {
    my ( $self, $mw_class_to_add, $args, $target_mw_class ) = @_;

    my $mw = $self->_to_middleware( $mw_class_to_add, $args );
    my $before_target
        = ( tied %{ $self->{middlewares} } )->key_before($target_mw_class);
    ( tied %{ $self->{middlewares} } )
        ->insert( $mw_class_to_add => $mw, $before_target );
}

sub to_app {
    my ( $self, $app ) = @_;

    for my $mw_class ( reverse keys %{ $self->{middlewares} } ) {
        my $mw = $self->{middlewares}->{$mw_class};
        $app = $mw->($app);
    }
    $app;
}

sub _to_middleware {
    my ( $self, $mw_class, $args ) = @_;

    eval "use $mw_class";
    die $@ if $@;

    my @args = ();
    while ( my ( $key, $value ) = each( %{ $args || {} } ) ) {
        push @args, $key;
        push @args, $value;
    }

    my $mw = sub { $mw_class->wrap( $_[0], @args ) };
    $mw;
}

sub middleware_classes {
    keys %{ shift->{middlewares} };
}

1;

__END__

=encoding utf-8

=head1 NAME

PlackX::MiddlewareStack -

=head1 SYNOPSIS

  use PlackX::MiddlewareStack;

=head1 DESCRIPTION

PlackX::MiddlewareStack is


=head1 SOURCE AVAILABILITY

This source is in Github:

  http://github.com/dann/

=head1 CONTRIBUTORS

Many thanks to:


=head1 AUTHOR

Takatoshi Kitano E<lt>kitano.tk@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
