# Pragmas.
use strict;
use warnings;

# Modules.
use Encode qw(decode_utf8);
use Map::Tube::Nanjing;
use Test::More tests => 3;
use Test::NoWarnings;

# Test.
my $map = Map::Tube::Nanjing->new;
my $ret = $map->get_node_by_name('foo');
is($ret, undef, 'Get node for bad node name.');

# Test.
my @ret = sort map { $_->id } $map->get_node_by_name(decode_utf8('中华门'));
is_deeply(
	\@ret,
	[
		'1-11',
	],
	"Get all nodes for '中华门'.",
);
