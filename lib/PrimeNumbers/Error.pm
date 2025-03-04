package PrimeNumbers::Error;
use v5.40;
use utf8;
use experimental 'class';

class PrimeNumbers::Error {
    field $message :param :reader;
}

class PrimeNumbers::Error::InvalidInput :isa(PrimeNumbers::Error) {
}
