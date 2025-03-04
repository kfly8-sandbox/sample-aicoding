use v5.40;
use utf8;
use experimental 'class';

class PrimeNumbers::Error {
    field $message :param :reader;
}

__END__

=encoding utf-8

=head1 NAME

PrimeNumbers::Error - エラーの基底クラス

=head1 SYNOPSIS

    class PrimeNumbers::Error::InvalidInput :isa(PrimeNumbers::Error) {}

    my $error = PrimeNumbers::Error::InvalidInput->new(
        message => '入力は1以上の整数である必要があります'
    );

    say $error->message;

=head1 DESCRIPTION

このモジュールはPrimeNumberのエラーの基底クラスです。
利用する場合は、エラータイプごとに専用のサブクラスを定義して利用します。

=head1 METHODS

=head2 message

エラーメッセージ

