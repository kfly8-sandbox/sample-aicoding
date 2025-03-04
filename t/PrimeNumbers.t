use v5.40;
use utf8;
use Test2::V0;

use PrimeNumbers qw(find_primes);

subtest 'find_primes' => sub {

    subtest '素数生成のケース' => sub {
        my @cases = (

            # 上限 => 期待される素数リスト
            1 => [],
            2 => [2],
            3 => [2, 3],
            10 => [2, 3, 5, 7],
            20 => [2, 3, 5, 7, 11, 13, 17, 19],
            30 => [2, 3, 5, 7, 11, 13, 17, 19, 23, 29],
        );

        for my ($limit, $expected) (@cases) {
            my ($result, $err) = find_primes($limit);
            is $err, undef, "find_primes($limit)はエラーなしで実行される";
            is $result, $expected, "find_primes($limit)は正しい素数のリストを返す";
        }
    };

    subtest 'エラー処理のケース' => sub {
        subtest '無効な入力の場合はエラーを返すこと' => sub {
            my @invalid_inputs = (
                0,          # 0以下は無効
                -1,         # 負の数は無効
                'abc',      # 文字列は無効
                undef,      # undefは無効
            );

            for my $input (@invalid_inputs) {
                my ($result, $err) = find_primes($input);
                my $input_str = defined $input ? $input : "undef";
                is $result, undef, "find_primes($input_str)は結果としてundefを返す";
                ok $err isa PrimeNumbers::Error::InvalidInput, "find_primes($input_str)はInvalidInputErrorを返す";
            }
        };
    };
};

done_testing;
