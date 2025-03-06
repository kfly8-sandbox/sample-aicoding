use v5.40;
use utf8;
use Test2::V0;

use Prime::Checker qw(is_prime);

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

    subtest '入力が自然数でない場合、エラーを返す' => sub {
        my @cases = (
            # input
            0,
            -1,
            -5,
            'a',
            '',
            undef,
        );

        for my ($input) (@cases) {
            my $input_str = defined $input ? $input : 'undef';
            my ($result, $err) = is_prime($input);
            is $result, undef, "no result for $input_str";
            ok $err, "error exists for $input_str";
            is ref($err), 'Prime::Error::InvalidInput', "error type check for $input_str";
        }
    };
};

done_testing;
