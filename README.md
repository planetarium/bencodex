Bencodex: Bencoding Extended
============================

Bencodex is a serialization format that extends BitTorrent's [Bencoding].
Since it is a superset of Bencoding, every valid Bencoding representation is
a valid Bencodex representation of the same meaning (i.e., represents the same
value).  Bencodex adds the below data types to Bencoding:

 -  null
 -  Boolean values
 -  Unicode strings besides byte strings
 -  Dictionaries with both byte and Unicode string keys

[Bencoding]: http://www.bittorrent.org/beps/bep_0003.html#bencoding


Why not *[insert your favorite format here]*
--------------------------------------------

The unique feature of Bencoding is forced normalization.
According to Wikipedia's [Bencode] page:

> For each possible (complex) value, there is only a single valid bencoding;
> i.e. there is a [bijection] between values and their encodings.
> This has the advantage that applications may compare bencoded values by
> comparing their encoded forms, eliminating the need to decode the values.

This makes things really simple when an application needs to determine
if encoded values are the same, in particular, with cryptographic hash or
digital signatures.

There have been countless improvements in data serialization like
rich data types, human readability, compact binary representation,
zero-copy serialization, and even streaming, but canonical representation
is still not well counted.

Bencodex actually does not aim high in ambition; it purposes to merely
leverage Bencoding's good things with average-level data types of modern
serialization formats.

[Bencode]: https://en.wikipedia.org/wiki/Bencode#Features_&_drawbacks
[bijection]: https://en.wikipedia.org/wiki/Bijection


Encoding
--------

Note that notations for the semantics (i.e., the values that encodings
represent) use Python's literals.

 -  Null is represented by `n` (`6e`).

 -  Boolean true is represented by `t` (`74`),
    and false is represented by `f` (`66`).

 -  Byte strings are length-prefixed base 10 followed by a colon and
    the byte string.

    For example, `4:spam` (`34 3a 73 70 61 6d`) corresponds to `b"spam"`.

 -  Unicode strings are represented by `u` followed by UTF-8 byte length
    base 10 and UTF-8 encoding of the Unicode string.

    For example, `u6:단팥` (`75 36 3a eb 8b a8 ed 8c a5`) corresponds to
    `u"\ub2e8\ud325"`.

 -  Integers are represented by an `i` followed by the number in base 10
    followed by an `e`.

    For example, `i3e` (`69 33 65`) corresponds to `3`,
    and `i-3e` (`69 2d 33 65`) corresponds to `-3`.

    Integers have no size limitation.

    `i-0e` (`69 2d 30 65`) is invalid.  All encodings with a leading zero,
    such as `i03e` (`69 30 33 65`), are invalid, other than `i0e` (`69 30 65`),
    which of course corresponds to `0`.

 -  Lists are encoded as an `l` followed by their elements (also represented in
    Bencodex) followed by an `e`.

    For example, `l4:spamu4:eggse` (`6c 34 3a 73 70 61 6d 75 34 3a 65 67 67 73
    65`) corresponds to `[b"spam", u"eggs"]`.

 -  Dictionaries are encoded as a `d` followed by a list of alternating keys
    and their corresponding values followed by an `e`.

    For example, `d3:cowu3:moou4:spam4:eggse` (`64 33 3a 63 6f 77 75 33 3a 6d
    6f 6f 75 34 3a 73 70 61 6d 34 3a 65 67 67 73 65`) corresponds to
    `{b"cow": u"moo", u"spam": b"eggs"}`, and `du4:spaml1:au1:bee` (`64 75 34
    3a 73 70 61 6d 6c 31 3a 61 75 31 3a 62 65 65`) corresponds to
    `{u"spam": [b"a", u"b"]}`.

    Keys must be Unicode or byte strings, and appear in the certain order:

     -  Unicode strings do not appear earlier than byte strings.
     -  Byte strings are sorted as raw strings, not alphanumerics.
     -  Unicode strings are sorted as their UTF-8 representations,
        not any collation order or chart order listed by Unicode.

    `du1:k1:v1:k1:ve` (`64 75 31 3a 6b 31 3a 76 31 3a 6b 31 3a 76 65`) is
    invalid because `u1:k` appear earlier than `1:k`.


Test suite
----------

The *testsuite/* directory contains a set of Bencodex tests.  Every test case
is a pair of two files; *.dat* is an arbitrary Bencodex data, and a *.yaml*
is its corresponding value in YAML.  For example, *list.dat* contains
the below Bencodex data:

~~~~ bencodex
lu16:a Unicode string13:a byte stringi123ei-456etfndu1:au4:dictelu1:au4:listee
~~~~

which encodes the value corresponding to *list.yaml*, that is:

~~~~ yaml
- a Unicode string
- !!binary "YSBieXRlIHN0cmluZw=="  # b"a byte string"
- 123
- -456
- true
- false
- null
- a: dict
- [a, list]
~~~~

An implementation should satisfy the below rules:

 -  Bytes that an encoder builds from a YAML content should be exactly same to
    the contents of a *.dat* file that corresponds to the *.yaml* file.

 -  A content a decoder read from a *.dat* file should be equivalent to
    the content of a *.yaml* file that corresponds to the *.dat* file.


----

This document (*README.md*) and every content in this repository including
the test suite (*testsuite/*) are in the public domain.
