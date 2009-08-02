use Test::More qw( no_plan );

BEGIN { our $class = 'DesignPattern::DispatchTable'; use_ok $class; }

isa_ok $dt = $class->new(), q{I can create an empty dispatch table...};
ok $dt->register( 'METHOD CALL' => sub { return 1 } ),
  q{   ... and add a string based call};
ok $dt->register( qr{(THIS|THAT)} => sub { return 2 } ),
  q{   ... and add a regular expression based call};

ok $dt->call('METHOD CALL') == 1,
  q{I can call the method attached to the string};
ok $dt->call('THIS') == 2,      q{   ... and my regular expression triggers};
ok $dt->call('EVEN THAT') == 2, q{   ... for all alternatives};

ok ref( $code = $dt->code_for('METHOD CALL') ) eq 'CODE',
  q{I can fetch the sub corresponding to 'METHOD CALL'};
ok $code->() == 1, q{   ... and calling it returns the right value};

ok !$dt->register( 'METHOD CALL' => sub { return 3 } ),
  q{I can't register the same key twice};
ok $dt->register( 'METHOD CALL' => sub { return 3 }, 'override' ),
  q{   ... unless I pass in a "force" option };
ok $dt->call('METHOD CALL') == 3, q{   ... and the old value is discarded};

