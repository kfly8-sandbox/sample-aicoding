package Prime::Checker;

=pod

=encoding utf8

=head1 NAME

Prime::Checker - 素数判定モジュール

=head1 SYNOPSIS

    use Prime::Checker qw(is_prime);
    
    my ($result, $err) = is_prime(7);
    if ($err) {
        die $err->message;
    }
    
    if ($result) {
        say "7 is a prime number";
    } else {
        say "7 is not a prime number";
    }

=head1 DESCRIPTION

自然数が素数かどうかを判定するモジュールです。

=head1 FUNCTIONS

=cut

use v5.40;
use utf8;
use experimental 'class';

use Types::Standard -types;
use Syntax::Keyword::Assert;
use kura PrimeNumber => InstanceOf['Prime::Number'];
use kura NaturalNumber => Int & sub { $_ > 0 };
use kura ErrorInvalidInput => InstanceOf['Prime::Error::InvalidInput'];
use Result::Simple;

use Exporter 'import';
our @EXPORT_OK = qw(is_prime);

use Prime::Error;

=pod

=head2 is_prime($n)

与えられた自然数が素数かどうかを判定します。

例:
    my ($result, $err) = is_prime(7);
    # $result = 1, $err = undef

@params
    $n: 判定する自然数

@return
    Result(Bool, ErrorInvalidInput): 素数であれば真、そうでなければ偽を返します。入力が無効な場合はエラーを返します。

@algorithm
    1. 入力が自然数かチェック
    2. 1は素数ではない
    3. 2は素数
    4. 3以上の場合、2から平方根までの数で割り切れるかチェック
    5. 割り切れる数がなければ素数と判定

=cut

sub is_prime :Result(Bool, ErrorInvalidInput) ($n) {
    # 入力チェック: 自然数であること
    unless (defined $n && NaturalNumber->check($n)) {
        return Err(Prime::Error::InvalidInput->new(
            message => "入力は自然数である必要があります: " . (defined $n ? $n : "undef")
        ));
    }
    
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

