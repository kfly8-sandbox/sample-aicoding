package PrimeNumbers;

=pod
=encoding utf-8

=head1 NAME

PrimeNumbers - 指定された整数以下の全ての素数を発見するモジュール

=head1 SYNOPSIS

  use PrimeNumbers qw(find_primes);

  my ($primes, $err) = find_primes(100);
  if ($err) {
      die $err->message;
  }

  for my $prime (@$primes) {
      say $prime;
  }

=head1 DESCRIPTION

このモジュールは、指定された整数以下の全ての素数を効率的に発見する機能を提供します。
エラトステネスのふるいアルゴリズムを使用して素数を計算します。

=head1 FUNCTIONS

=cut

use v5.40;
use utf8;
use experimental 'class';

use Exporter 'import';
use Result::Simple;
use Types::Standard -types;
use Syntax::Keyword::Assert;

class PrimeNumbers::Error::InvalidInput :isa(PrimeNumbers::Error) {}

use kura PrimeLimit => Int & sub { $_ > 0 };
use kura PrimeList => ArrayRef[Int];
use kura InvalidInputError => InstanceOf['PrimeNumbers::Error::InvalidInput'];

our @EXPORT_OK = qw(find_primes);

=pod

=head2 find_primes($limit) -> Result(PrimeList, InvalidInputError)

指定された整数以下の全ての素数を返す

    my ($primes, $err) = find_primes(20);
    # $primes = [2, 3, 5, 7, 11, 13, 17, 19]

    @params $limit PositiveInt - 素数を探す上限値（1以上の整数）
    @return
        * Ok(PrimeList) - 素数のリスト
        * Err(InvalidInputError) - 入力値が1以上の整数でないエラー

エラトステネスのふるいアルゴリズムを使用しています。

    1. 2からnまでの整数のリストを作成
    2. 最小の未処理の数を素数とマーク
    3. その素数の倍数を全て除外
    4. 未処理の数が残っていれば2に戻る

=cut

# 指定された整数以下の全ての素数を見つける関数
# エラトステネスのふるいアルゴリズムを使用
sub find_primes :Result(PrimeList, InvalidInputError) ($limit) {

    # 入力の検証
    if (!defined $limit || !PrimeLimit->check($limit)) {
        return Err(
            PrimeNumbers::Error::InvalidInput->new(
                message => '入力は1以上の整数である必要があります'
            )
        );
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
