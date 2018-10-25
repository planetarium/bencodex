Bencodex: Bencoding Extended
============================

Bencodex is a serialization format that extends BitTorrent's [Bencoding].
Since it is a superset of Bencoding, every valid Bencoding representation is
a valid Bencodex representation of the same meaning (i.e., represents the same
value).   This adds the below data types to Bencoding:

 -  null
 -  Boolean values
 -  Unicode strings besides byte strings
 -  Dictionaries having Unicode keys

[Bencoding]: http://www.bittorrent.org/beps/bep_0003.html#bencoding


Why not *[insert your favorite format here]*
--------------------------------------------

The unique feature of Bencoding is forced normalization.
According Wikipedia's [Bencode] page:

> For each possible (complex) value, there is only a single valid bencoding;
> i.e. there is a [bijection] between values and their encodings.
> This has the advantage that applications may compare bencoded values by
> comparing their encoded forms, eliminating the need to decode the values.

This makes things really simple when an application need to determine
if encoded values are the same, in particular, with cryptographic hash or
digital signatures.

There have been countless improvements on data serialization like
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

 -  There are two types of dictionaries: one with byte string keys and other
    one with Unicode string keys.  Key types are homogeneous in a dictionary.

    In the same manner to Bencoding, dictionaries having byte string keys
    are encoded as a lowercase `d` followed by a list of alternating keys
    and their corresponding values followed by an `e`.

    Dictionaries having Unicode string keys are encoded as an uppercase `D`
    followed by a list of alternating keys and their corresponding values
    followed by an `e`.

    For example, `d3:cow3:moo4:spam4:eggse` (`64 33 3a 63 6f 77 33 3a 6d 6f 6f
    34 3a 73 70 61 6d 34 3a 65 67 67 73 65`) corresponds to
    `{b"cow": b"moo", b"spam": b"eggs"}`, and `Du4:spaml1:au1:bee` (`44 75 34
    3a 73 70 61 6d 6c 31 3a 61 75 31 3a 62 65 65`) corresponds to
    `{u"spam": [b"a", u"b"]}`.

    Keys must appear in the certain order:

     -  Byte strings are sorted as raw strings, not alphanumerics.
     -  Unicode strings are sorted as their UTF-8 representations,
        not any collation order or chart order listed by Unicode.

    `du1:k1:ve` (`64 75 31 3a 6b 31 3a 76 65`) is invalid because a Unicode
    key (`u1:k`) must not appear in a dictionary of byte string keys.

    `D1:ku1:ve` (`44 31 3a 6b 75 31 3a 76 65`) is invalid because a byte string
    key (`1:k`) must not appear in a dictionary of Unicode keys.
