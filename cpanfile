requires "perl", "5.040000";

requires 'Type::Tiny';
requires 'Result::Simple';
requires 'kura';
requires 'Syntax::Keyword::Assert';

on 'test' => sub {
    requires 'Test2::V0';
};

on 'develop' => sub {
    requires 'Perl::Critic';
    requires 'Perl::Tidy';
    requires 'App::perlimports';
};
