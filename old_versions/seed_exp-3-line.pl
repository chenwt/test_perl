# This script is designed for calculating  diff_exp
# Input file: seed1  seed2 ~ ~
# stat file: seed exp len  ~ ~
# Date: 2010-10-22
# Auther: wangm@yeah.net


#! /user/bin/perl -w
use strict;

unless(defined @ARGV){
    print "usage:perl seed_exp.pl  B42-0_B42-6.blast  seed_BRv-0.stat seed_B42-0.stat seed_B42-6.stat\n";
    exit 0;
}

my $f1=shift; # Input the ncRNA list file.
open F1,"$f1" or die "Cannot open file $!.\n";

#############################################
# store ncRNA expression.
#############################################
my $f2=shift; #BRv-0 seed stat
my $f3=shift; #B42-0 seed stat
my $f4=shift; #B42-6 seed stat 
open F2,"$f2" or die "Cannot open file $!.\n"; # BRv-0
open F3,"$f3" or die "Cannot open file $!.\n"; # B42-0
open F4,"$f4" or die "Cannot open file $!.\n"; # B42-6

my %hs;
while(<F2>){
    chomp;
    my @ps=split/\t/;
    $hs{'BRv-0'}->{$ps[0]}=[@ps];
    }
while(<F3>){
    chomp;
    my @ps=split/\t/;
    $hs{'B42-0'}->{$ps[0]}=[@ps];
    }
while(<F4>){
    chomp;
    my @ps=split/\t/;
    $hs{'B42-6'}->{$ps[0]}=[@ps];
    }

my ($a,$b,$c);
my $count=1;
while(<F1>){
    chomp;
    my @ps=split/\t/;
# get sample name of BRv-0:
if($ps[0]=~/^BRv/){$a='BRv-0';}
  elsif($ps[0]=~/^B42\-0/){$a='B42-0';}
   elsif($ps[0]=~/^B42\-6/){$a='B42-6';}
# get sample name of B42-0:
if($ps[1]=~/^BRv/){$b='BRv-0';}
  elsif($ps[1]=~/^B42\-0/){$b='B42-0';}
   elsif($ps[1]=~/^B42\-6/){$b='B42-6';}
# get sample name of B42-6:
if($ps[2]=~/^BRv/){$c='BRv-0';}
  elsif($ps[2]=~/^B42\-0/){$c='B42-0';}
   elsif($ps[2]=~/^B42\-6/){$c='B42-6';}

# Header
if($count==1){
print "$a\t$b\t$c\tlen\_$a\tlen\_$b\tlen\_$c\texp\_$a\texp\_$b\texp\_$c\tlog2\($b\/$a\)\tlog2\($c\/$b\)\tp\-value\-1\tp\-value\-2\n";
$count++;
}

my $len1=$hs{$a}->{$ps[0]}[2];
my $len2=$hs{$b}->{$ps[1]}[2];
my $len3=$hs{$c}->{$ps[2]}[2];
my $exp1=$hs{$a}->{$ps[0]}[1];
my $exp2=$hs{$b}->{$ps[1]}[1];
my $exp3=$hs{$c}->{$ps[2]}[1];

if($exp1==0){$exp1=0.001;}
if($exp2==0){$exp2=0.001;}
if($exp3==0){$exp3=0.001;}

my $log2_1=LOG2($exp2/$exp1);
my $p_val_1=P_val($exp1,$exp2);

my $log2_2=LOG2($exp3/$exp2);
my $p_val_2=P_val($exp2,$exp3);

printf "$ps[0]\t$ps[1]\t$ps[2]\t$len1\t$len2\t$len3\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%5.5g\t%5.5g\n",
$exp1,$exp2,$exp3,$log2_1,$log2_2,$p_val_1,$p_val_2;
}


sub P_val{
    my $x=shift;
    my $y=shift;
    my $N1=my $N2=1000000;
    my $p_v_log=$y*LOG10($N2/$N1)+log_fac($x+$y)-log_fac($x)-log_fac($y)-($x+$y+1)*LOG10(1+$N2/$N1);
return 10**$p_v_log;
}

sub log_fac{
        my $n=shift;
        my $log_fac;
        if($n==0){
                $n=1;
        }
        for(my $i=1; $i<=$n; $i++){
                $log_fac+=LOG10($i);
        }
        return $log_fac;
}

sub LOG10{
        my $m=shift;
      return  log($m)/log(10);
}

sub LOG2{
        my $m=shift;
      return  log($m)/log(2);
}


close F1;
close F2;
close F3;
close F4;
