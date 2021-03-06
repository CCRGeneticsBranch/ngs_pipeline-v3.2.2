#!/usr/bin/perl
use strict;
use warnings;
use List::Util qw(first);
###########################################################
#
#   Author: Rajesh Patidar rajbtpatidar@gmail.com
#   Parse defuse, tophat-fusion, fusion cather result to make 
#    actionable fusions based on some rules.
#
###########################################################
my $library        = $ARGV[0];
## my $defuse         = $ARGV[X];  NOT used 5/11/2018
my $tophat         = $ARGV[1];
my $fusioncatcher  = $ARGV[2];
my $star_fusion	   = $ARGV[3];
my $destination    = $ARGV[4];
print "#LeftGene\tRightGene\tChr_Left\tPosition\tChr_Right\tPosition\tSample\tTool\tSpanReadCount\n";
###########################################################
# Comment Defuse file parsing 5/11/2018
###########################################################
#unless (open(DEFUSE, "$defuse")){
#	print STDERR "Can not open the file $defuse\n";
#	exit;
#}
#unless (open(DEFUSE_OUT, ">$destination/$library.defuse.filtered.txt")){
#	print STDERR "Can not open the file $destination/$library.defuse.filtered.txt\n";
#	die $!;
#}
#my $idx;
#while(<DEFUSE>){
#	chomp;
#	my @local =split("\t", $_);
#	if($_ =~ /^cluster_id/){
#		print DEFUSE_OUT "$_\n"; 
#		$idx = first { $local[$_] eq 'span_count' } 0..$#local;
#		next;
#	}	
#	print DEFUSE_OUT "$_\n";
#	print "$local[30]\t$local[31]\tchr$local[24]\t$local[37]\tchr$local[25]\t$local[38]\t$library\tDefuse\t$local[$idx]\n";
#}
#close DEFUSE;
#close DEFUSE_OUT;
###########################################################
unless (open(TOP, "$tophat")){
        print STDERR "Can not open the file $tophat\n";
        exit;
}
unless (open(TOPHAT_OUT, ">$destination/$library.tophat.txt")){
	print STDERR "Can not open the file $destination/$library.tophat.txt\n";
	die $!;
}
while(<TOP>){
        chomp;
	my @local =split("\t", $_);
	if($_ =~ /Coordinate_left/){print TOPHAT_OUT "$_\n"; next}
	$local[3] = $local[3] + 1;
	$local[6] = $local[6] + 1;	
	print "$local[1]\t$local[4]\tchr$local[2]\t$local[3]\tchr$local[5]\t$local[6]\t$library\ttophatFusion\t$local[7]\n";
	print TOPHAT_OUT "$_\n";

}
close TOP;
close TOPHAT_OUT;
###########################################################
unless (open(FC, "$fusioncatcher")){
        print STDERR "Can not open the file $fusioncatcher\n";
        exit;
}
unless (open(FC_OUT, ">$destination/$library.fusion-catcher.txt")){
	print STDERR "Can not open the file $destination/$library.fusion-catcher.txt\n";
	die $!;
}
while(<FC>){
        chomp;
	my @local =split("\t", $_);
	if($_ =~ /^Gene_1_symbol/){print FC_OUT "$_\n"; next}
	if($_ =~ /not-converted/){next;}
	my @left  = split(":", $local[8]);
	my @right = split(":", $local[9]);
	print "$local[0]\t$local[1]\tchr$left[0]\t$left[1]\tchr$right[0]\t$right[1]\t$library\tFusionCatcher\t$local[5]\n";
	print FC_OUT "$_\n";
}
close FC;
close FC_OUT;

#############################################################
unless (open(SF, "$star_fusion")){
        print STDERR "Can not open the file $star_fusion\n";
        exit;
}
unless (open(SF_OUT, ">$destination/$library.STAR-fusion.txt")){
        print STDERR "Can not open the file $destination/$library.STAR-fusion.txt\n";
        die $!;
}
while(<SF>){
	chomp;
	my @local =split("\t", $_);
	if($_ =~ /#FusionName/){print SF_OUT "$_\n"; next}
	my @l_gene =split(/\^/, $local[4]);
	my @R_gene =split(/\^/, $local[6]);
	my @left  = split(":", $local[5]);
	my @right = split(":", $local[7]);
	print "$l_gene[0]\t$R_gene[0]\t$left[0]\t$left[1]\t$right[0]\t$right[1]\t$library\tSTAR-fusion\t$local[1]\n";
	print SF_OUT "$_\n";
}
close SF;
close SF_OUT;
