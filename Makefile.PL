use inc::Module::Install;
name 'PlackX-MiddlewareStack';
all_from 'lib/PlackX/MiddlewareStack.pm';

requires(

);
test_requires(
  'Test::More'                   => 0,
  'Test::Class'                  => 0,
  'Module::Install::AuthorTests' => 0,
);
use_test_base;
auto_include;
WriteAll;
