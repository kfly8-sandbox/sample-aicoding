package PrimeNumbers;

=pod
=encoding utf-8

=head1 NAME

PrimeNumbers - 指定された整数以下の全ての素数を発見するモジュール

=head1 SYNOPSIS

  use PrimeNumbers qw(find_primes is_prime);

  # 素数のリストを取得
  my ($primes, $err) = find_primes(100);
  if ($err) {
      die $err->message;
  }

  for my $prime (@$primes) {
      say $prime;
  }

  # 素数判定
  my ($is_prime, $err) = is_prime(17);
  if ($err) {
      die $err->message;
  }

  if ($is_prime) {
      say "17は素数です";
  } else {
      say "17は素数ではありません";
  }

=head1 DESCRIPTION

このモジュールは、指定された整数以下の全ての素数を効率的に発見する機能を提供します。
エラトステネスのふるいアルゴリズムを使用して素数を計算します。
また、個別の自然数が素数かどうかを判定する機能も提供します。

=head1 FUNCTIONS

=cut

use v5.40;
use utf8;
use experimental 'class';

use Exporter 'import';
use Result::Simple;
use Types::Standard -types;
use Syntax::Keyword::Assert;

class PrimeNumbers::Error {
    field $message :param :reader;
}

class PrimeNumbers::Error::InvalidInput :isa(PrimeNumbers::Error) {}

use kura PrimeLimit => Int & sub { $_ > 0 };
use kura PrimeList => ArrayRef[Int];
use kura NaturalNumber => Int & sub { $_ > 0 };
use kura InvalidInputError => InstanceOf['PrimeNumbers::Error::InvalidInput'];

our @EXPORT_OK = qw(find_primes is_prime);

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

=pod

=head2 is_prime($n) -> Result(Bool, InvalidInputError)

与えられた自然数が素数かどうかを判定します。

例:
    my ($result, $err) = is_prime(7);
    # $result = 1, $err = undef

@params
    $n: 判定する自然数

@return
    Result(Bool, InvalidInputError): 素数であれば真、そうでなければ偽を返します。

@algorithm
    1. 入力が自然数かチェック（エラーの場合は例外が発生）
    2. 1は素数ではない
    3. 2は素数
    4. 3以上の場合、2から平方根までの数で割り切れるかチェック
    5. 割り切れる数がなければ素数と判定

=cut

sub is_prime :Result(Bool, InvalidInputError) ($n) {
    # 入力が自然数であることを確認（自然数以外は想定外）
    assert(defined $n);
    assert(NaturalNumber->check($n));
    
    # 1は素数ではない
    if ($n == 1) {
        return Ok(0);
    }
    
    # 2は素数
    if ($n == 2) {
        return Ok(1);
    }
    
    # 2で割り切れるなら素数ではない
    if ($n % 2 == 0) {
        return Ok(0);
    }
    
    # 3以上の奇数の約数をチェック（3から平方根まで、奇数のみ）
    my $limit = int(sqrt($n));
    for (my $i = 3; $i <= $limit; $i += 2) {
        if ($n % $i == 0) {
            return Ok(0); # 割り切れるので素数ではない
        }
    }
    
    # どの数でも割り切れなかったので素数
    return Ok(1);
}
