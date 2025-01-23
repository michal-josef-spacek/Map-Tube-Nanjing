package Map::Tube::Nanjing;

use strict;
use warnings;
use 5.006;

use File::Share ':all';
use Moo;
use namespace::clean;

our $VERSION = 0.06;

# Get XML.
has xml => (
	'is' => 'ro',
	'default' => sub {
		return dist_file('Map-Tube-Nanjing', 'nanjing-map.xml');
	},
);

with 'Map::Tube';

1;

__END__

=encoding utf8

=head1 NAME

Map::Tube::Nanjing - Interface to the Nanjing Metro Map.

=head1 SYNOPSIS

 use Map::Tube::Nanjing;

 my $obj = Map::Tube::Nanjing->new;
 my $routes_ar = $obj->get_all_routes($from, $to);
 my $line = $obj->get_line_by_id($line_id);
 my $line = $obj->get_line_by_name($line_name);
 my $lines_ar = $obj->get_lines;
 my $station = $obj->get_node_by_id($station_id);
 my $station = $obj->get_node_by_name($station_name);
 my $route = $obj->get_shortest_route($from, $to);
 my $stations_ar = $obj->get_stations($line);
 my $metro_name = $obj->name;
 my $xml_file = $obj->xml;

=head1 DESCRIPTION

It currently provides functionality to find the shortest route between the two
given nodes.

For more information about Nanjing Map, click L<here|https://en.wikipedia.org/wiki/Nanjing_Metro>.

=head1 METHODS

=over 8

=item C<new()>

 Constructor.

=item C<get_all_routes($from, $to)> [EXPERIMENTAL]

 Get all routes from station to station.
 Returns reference to array with Map::Tube::Route objects.

=item C<get_line_by_id($line_id)>

 Get line object defined by id.
 Returns Map::Tube::Line object.

=item C<get_line_by_name($line_name)>

 Get line object defined by name.
 Returns Map::Tube::Line object.

=item C<get_lines()>

 Get lines in metro map.
 Returns reference to unsorted array with Map::Tube::Line objects.

=item C<get_node_by_id($station_id)>

 Get station node by id.
 Returns Map::Tube::Node object.

=item C<get_node_by_name($station_name)>

 Get station node by name.
 Returns Map::Tube::Node object.

=item C<get_shortest_route($from, $to)>

 Get shortest route between $from and $to node names. Node names in $from and $to are case insensitive.
 Returns Map::Tube::Route object.

=item C<get_stations($line)>

 Get list of stations for concrete metro line.
 Returns reference to array with Map::Tube::Node objects.

=item C<name()>

 Get metro name.
 Returns string with metro name.

=item C<xml()>

 Get XML specification of Nanjing metro.
 Returns string with XML.

=back

=head1 EXAMPLE1

=for comment filename=print_nanjing_route.pl

 use strict;
 use warnings;

 use Encode qw(decode_utf8 encode_utf8);
 use Map::Tube::Nanjing;

 # Object.
 my $obj = Map::Tube::Nanjing->new;

 # Get route.
 my $route = $obj->get_shortest_route(decode_utf8('鼓楼'), decode_utf8('大厂'));

 # Print out type.
 print "Route: ".encode_utf8($route)."\n";

 # Output:
 # Route: 鼓楼 (南京地铁1号线), 大厂 (宁天城际轨道交通)

=head1 EXAMPLE2

=for comment filename=print_nanjing_def_xml_file.pl

 use strict;
 use warnings;

 use Map::Tube::Nanjing;

 # Object.
 my $obj = Map::Tube::Nanjing->new;

 # Get XML file.
 my $xml_file = $obj->xml;

 # Print out XML file.
 print "XML file: $xml_file\n";

 # Output like:
 # XML file: .*/nanjing-map.xml

=head1 EXAMPLE3

=for comment filename=print_nanjing_image.pl

 use strict;
 use warnings;

 use Map::Tube::GraphViz;
 use Map::Tube::GraphViz::Utils qw(node_color_without_label);
 use Map::Tube::Nanjing;

 # Object.
 my $obj = Map::Tube::Nanjing->new;

 # GraphViz object.
 my $g = Map::Tube::GraphViz->new(
         'callback_node' => \&node_color_without_label,
         'driver' => 'neato',
         'tube' => $obj,
 );

 # Get graph to file.
 $g->graph('Nanjing.png');

 # Print file.
 system "ls -l Nanjing.png";

 # Output like:
 # -rw-r--r-- 1 skim skim 336513 21. led 21.02 Nanjing.png

=begin html

<a href="https://raw.githubusercontent.com/michal-josef-spacek/Map-Tube-Nanjing/master/images/Nanjing.png">
  <img src="https://raw.githubusercontent.com/michal-josef-spacek/Map-Tube-Nanjing/master/images/Nanjing.png" alt="南京地铁" width="300px" height="300px" />
</a>

=end html

=head1 EXAMPLE4

=for comment filename=print_nanjing_lines.pl

 use strict;
 use warnings;

 use Encode qw(encode_utf8);
 use Map::Tube::Nanjing;

 # Object.
 my $obj = Map::Tube::Nanjing->new;

 # Get lines.
 my $lines_ar = $obj->get_lines;

 # Print out.
 map { print encode_utf8($_->name)."\n"; } sort @{$lines_ar};

 # Output:
 # 南京地铁10号线
 # 南京地铁1号线
 # 南京地铁2号线
 # 南京地铁3号线
 # 宁天城际轨道交通
 # 宁高城际轨道交通

=head1 EXAMPLE5

=for comment filename=print_nanjing_line_stations.pl

 use strict;
 use warnings;

 use Encode qw(decode_utf8 encode_utf8);
 use Map::Tube::Nanjing;

 # Arguments.
 if (@ARGV < 1) {
         print STDERR "Usage: $0 line\n";
         exit 1;
 }
 my $line = decode_utf8($ARGV[0]);

 # Object.
 my $obj = Map::Tube::Nanjing->new;

 # Get stations for line.
 my $stations_ar = $obj->get_stations($line);

 # Print out.
 map { print encode_utf8($_->name)."\n"; } @{$stations_ar};

 # Output:
 # Usage: __PROG__ line

 # Output with 'foo' argument.
 # Map::Tube::get_stations(): ERROR: Invalid Line Name [foo]. (status: 105) file __PROG__ on line __LINE__

 # Output with '南京地铁1号线' argument.
 # 迈皋桥
 # 红山动物园
 # 南京站
 # 新模范马路
 # 玄武门
 # 鼓楼
 # 珠江路
 # 新街口
 # 张府园
 # 三山街
 # 中华门
 # 安德门
 # 天隆寺
 # 软件大道
 # 花神庙
 # 南京南站
 # 双龙大道
 # 河定桥
 # 胜太路
 # 百家湖
 # 小龙湾
 # 竹山路
 # 天印大道
 # 龙眠大道
 # 南医大·江苏经贸学院
 # 南京交院
 # 中国药科大学

=head1 DEPENDENCIES

L<File::Share>,
L<Map::Tube>,
L<Moo>,
L<namespace::clean>.

=head1 SEE ALSO

=over

=item L<Map::Tube>

Core library as Role (Moo) to process map data.

=item L<Task::Map::Tube>

Install the Map::Tube modules.

=item L<Task::Map::Tube::Metro>

Install the Map::Tube concrete metro modules.

=back

=head1 REPOSITORY

L<https://github.com/michal-josef-spacek/Map-Tube-Nanjing>

=head1 AUTHOR

Michal Josef Špaček L<mailto:skim@cpan.org>

L<http://skim.cz>

=head1 LICENSE AND COPYRIGHT

© 2014-2025 Michal Josef Špaček

Artistic License

BSD 2-Clause License

=head1 VERSION

0.06

=cut
