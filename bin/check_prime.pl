#!/usr/bin/env perl
use v5.40;
use utf8;
use FindBin;
use lib "$FindBin::Bin/../lib";
use open qw/:std :utf8/;

use Prime::Checker qw(is_prime);

my $number = shift @ARGV // die "Usage: $0 <number>\n";

my ($result, $err) = is_prime($number);

if ($err) {
    die $err->message . "\n";
}

if ($result) {
    say "$number は素数です。";
} else {
    say "$number は素数ではありません。";
}
