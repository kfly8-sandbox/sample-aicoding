use v5.40;
use utf8;
use Test2::V0;

use PrimeNumbers qw(find_primes is_prime);

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

subtest 'is_prime' => sub {
    subtest '与えられた自然数が素数の場合、真を返す' => sub {
        my @cases = (
            # input => expected
            2  => 1,
            3  => 1,
            5  => 1,
            7  => 1,
            11 => 1,
            13 => 1,
            17 => 1,
            19 => 1,
            23 => 1,
            29 => 1,
            97 => 1,
        );

        for my ($input, $expected) (@cases) {
            my ($result, $err) = is_prime($input);
            is $result, $expected, "$input is prime";
            is $err, undef, "no error";
        }
    };

    subtest '与えられた自然数が素数でない場合、偽を返す' => sub {
        my @cases = (
            # input => expected
            1  => 0,  # 1は素数ではない
            4  => 0,
            6  => 0,
            8  => 0,
            9  => 0,
            10 => 0,
            12 => 0,
            15 => 0,
            25 => 0,
            100 => 0,
        );

        for my ($input, $expected) (@cases) {
            my ($result, $err) = is_prime($input);
            is $result, $expected, "$input is not prime";
            is $err, undef, "no error";
        }
    };

    subtest '入力が自然数でない場合、例外が発生する' => sub {
        my @invalid_inputs = (
            0,          # 0以下は無効
            -1,         # 負の数は無効
            'abc',      # 文字列は無効
        );

        for my $input (@invalid_inputs) {
            my $input_str = defined $input ? $input : "undef";
            like dies { is_prime($input) }, qr/Assertion failed/, "is_prime($input_str)は例外を発生させる";
        }

        # undefの場合も例外が発生することを確認
        like dies { is_prime(undef) }, qr/Assertion failed/, "is_prime(undef)は例外を発生させる";
    };
};

done_testing;
