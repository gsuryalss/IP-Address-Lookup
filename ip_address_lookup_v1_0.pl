#!/usr/bin/perl

####################################################################################
#																					
# IP Address Finder																	
# Copyright (C) 2016 surya 															
#																					
# This program is free software: you can redistribute it and/or modify				
# it under the terms of the GNU General Public License as published by				
# the Free Software Foundation, either version 3 of the License, or					
# (at your option) any later version.												
#																					
# please see the GNU General Public License for more details.						
# <http://www.gnu.org/licenses/>													
#																						
# Usage : Retrieves IP address details in JSON format and write it in text file.	
# API Courtesy : http://ip-api.com/													
#																					
# Version log :  																	
#				- 10/10/2016 Initial version	
#				- 10/14/2016 Added IP Address Validaiton
#####################################################################################
use strict;
use warnings;
use HTTP::Tiny qw(get);
use JSON::MaybeXS qw(decode_json);
use DATA::Validate::IP qw(is_ip);

# header format
print "*"x50,"\n";
print "*"," "x10,"IP Address Lookup Utility"," "x13,"*","\n";
print "*"x50,"\n";
print "Please Enter the IP Address : ";

# IP Input
my $ip_val = <STDIN>;
&trim_val($ip_val);

# API End point url
my $api_url = "http://ip-api.com/json/";
my $file_op = "ip_finder_op.txt";

#var initializations
my $ht_valid = Data::Validate::IP->new;
my $ht_init = HTTP::Tiny->new;

#output file
open(my $fout, '>','C:/tmp/'.$file_op) or die "Could not open the file $file_op due to $!\n";

if($ht_valid->is_ip($ip_val)) {

	my $response = $ht_init->get($api_url.$ip_val);
	my $data_structure = decode_json($response->{content});
	
	($data_structure->{'status'} eq 'success' )? print "\npass\n" : print "\nfail\n" ; 	

	# prints the response
	foreach my $tmp_val (keys %$data_structure){
		print $fout $tmp_val," ","-"," ",$data_structure->{$tmp_val},"\n";
	}
		
	print "\n\nplease refer the output file - C:\\tmp\\$file_op\n";
}
else {
	print "\nplease verify the entered ip address - $ip_val\n";
}
close $fout;


# sub routine for removing spaces
sub trim_val{
	chomp($ip_val);
	$ip_val =~ s/\s//ig;
	return;
}
