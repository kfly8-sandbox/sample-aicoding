package PrimeNumbers::Error;
use v5.40;
use utf8;
use experimental 'class';

=head1 NAME

PrimeNumbers::Error - PrimeNumbersモジュールで使用するエラークラス

=head1 SYNOPSIS

  use PrimeNumbers::Error;
  
  my $error = PrimeNumbers::Error::InvalidInput->new(
      message => '入力は1以上の整数である必要があります'
  );
  
  say $error->message;

=head1 DESCRIPTION

このモジュールは、PrimeNumbersモジュールで使用するエラークラスを提供します。
エラータイプごとに専用のサブクラスを定義しています。

=head1 CLASSES

=head2 PrimeNumbers::Error

基本エラークラス。全ての特定エラークラスの親クラスです。

=head3 属性

=over 4

=item message

エラーメッセージを格納します。読み取り専用です。

=back

=head2 PrimeNumbers::Error::InvalidInput

無効な入力が与えられた場合に使用されるエラークラスです。
PrimeNumbers::Errorを継承しています。

=head1 AUTHOR

開発者

=head1 LICENSE

指定なし

=cut

class PrimeNumbers::Error {
    field $message :param :reader;
}

class PrimeNumbers::Error::InvalidInput :isa(PrimeNumbers::Error) {
}
