use Test::Dependencies
    exclude => [qw/Test::Dependencies Test::Base Test::Perl::Critic PlackX::MiddlewareStack/],
    style   => 'light';
ok_dependencies();
