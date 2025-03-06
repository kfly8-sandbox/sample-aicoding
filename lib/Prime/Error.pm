package Prime::Error;
use v5.40;
use utf8;
use experimental 'class';

class Prime::Error {
    field $message :param :reader;
}

class Prime::Error::InvalidInput :isa(Prime::Error);

