requires 'perl', '5.40';

requires 'Type::Tiny';
requires 'Result::Simple';
requires 'kura';
requires 'Syntax::Keyword::Assert';

on 'test' => sub {
    requires 'Test2::V0';
};
