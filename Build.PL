use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'DesignPattern::DispatchTable',
    license             => 'perl',
    dist_author         => 'Luis Motta Campos <lmc@cpan.org>',
    dist_version_from   => 'lib/DesignPattern/DispatchTable.pm',
    build_requires => {
        'Test::More' => 0,
    },
    add_to_cleanup      => [ 'DesignPattern-DispatchTable-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
