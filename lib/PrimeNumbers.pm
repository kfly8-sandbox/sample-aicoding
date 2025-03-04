package PrimeNumbers;
use v5.40;
use utf8;

# NAME
#
# PrimeNumbers - 指定された整数以下の全ての素数を発見するモジュール
#
# SYNOPSIS
#
#   use PrimeNumbers qw(find_primes);
#
#   my ($primes, $err) = find_primes(100);
#   if ($err) {
#       die $err->message;
#   }
#
#   for my $prime (@$primes) {
#       say $prime;
#   }
#
# DESCRIPTION
#
# このモジュールは、指定された整数以下の全ての素数を効率的に発見する機能を提供します。
# エラトステネスのふるいアルゴリズムを使用して素数を計算します。

use Exporter 'import';
use Result::Simple;
use Types::Standard -types;
use Syntax::Keyword::Assert;

use kura PrimeLimit => Int & sub { $_ > 0 };
use kura PrimeList => ArrayRef[Int];
use kura InvalidInputError => InstanceOf['PrimeNumbers::Error::InvalidInput'];

require PrimeNumbers::Error;

our @EXPORT_OK = qw(find_primes);

# 指定された整数以下の全ての素数を見つける関数
# エラトステネスのふるいアルゴリズムを使用
sub find_primes :Result(PrimeList, InvalidInputError) ($limit) {
    # 入力の検証
    if (!defined $limit || !PrimeLimit->check($limit)) {
        return Err(PrimeNumbers::Error::InvalidInput->new(
            message => '入力は1以上の整数である必要があります'
        ));
    }

    # 1以下の場合は空のリストを返す
    if ($limit < 2) {
        return Ok([]);
    }

    # エラトステネスのふるいアルゴリズムを実装
    my @sieve = (1) x ($limit + 1);
    $sieve[0] = $sieve[1] = 0; # 0と1は素数ではない

    for my $i (2 .. int(sqrt($limit))) {
        if ($sieve[$i]) {
            for (my $j = $i * $i; $j <= $limit; $j += $i) {
                $sieve[$j] = 0;
            }
        }
    }

    # 素数のリストを作成
    my @primes;
    for my $i (2 .. $limit) {
        if ($sieve[$i]) {
            push @primes, $i;
        }
    }

    return Ok(\@primes);
}
