#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'DesignPattern::DispatchTable' );
}

diag( "Testing DesignPattern::DispatchTable $DesignPattern::DispatchTable::VERSION, Perl $], $^X" );
