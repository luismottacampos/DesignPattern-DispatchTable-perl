use Test::More tests => 10;

BEGIN { our $class = 'DesignPattern::DispatchTable'; use_ok $class; }

can_ok $class, qw( register call );

isa_ok $dt = $class->new(), $class, q{I can create an empty dispatch table...};

ok $dt->register( 'METHOD CALL' => sub { return 1 } ),
  q{   ... and add a string based call};
ok $dt->register( qr{(THIS|THAT)} => sub { return 2 } ),
  q{   ... and add a regular expression based call};

ok $dt->call('METHOD CALL') == 1,
  q{I can call the method attached to the string};
ok $dt->call('THIS') == 2,      q{   ... and my regular expression triggers};
ok $dt->call('EVEN THAT') == 2, q{   ... for all alternatives};

ok $dt->register( 'METHOD CALL' => sub { return 3 } ),
  q{Registering the same key twice discards the previous handler};
ok $dt->call('METHOD CALL') == 3, q{   ... and the new code is used};

