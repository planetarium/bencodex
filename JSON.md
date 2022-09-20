Bencodex JSON Representation
===========================

Introduction
------------

Bencodex JSON Representation is a standard way to represent a given Bencodex
value to a valid JSON value to be interchanged.

This specification defines a standard way to represent a Bencodex value to (a
subset of) JSON and how to decode/encode them.

### Conventions Used in This Document

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD",
"SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this
document are to be interpreted as described in BCP 14[^RFC-2119] when, and only
when, they appear in all capitals, as shown here.

Prefixes
--------

Bencodex JSON Representation defines a set of prefixes that **SHALL** be used
for JSON[^JSON] string value to denote a corresponding Bencodex type. The
defined prefixes are following:

- `0x` denotes a hexadecimal byte string. The rest of the string **SHOULD** be
parsed as a byte-string encoded in hexadecimal.
  - The hexadecimal byte string **SHOULD NOT** contain any upper letters.
  - The casing of the value **SHOULD** be ignored.
- `U+FEFF BYTE ORDER MARK` denotes a Unicode string. The rest of the string
**MUST** be parsed as a Unicode string.
- `b64:` denotes a base64-encoded byte string. The rest of the string **MUST**
be parsed as a byte string encoded in base64 as defined in
[RFC 4648](https://www.rfc-editor.org/rfc/rfc4648.html)[^RFC-4648].
- In case no prefixes mentioned above are found, the value of the string
**MUST** be parsed as an integer and having any non-digit character in the
string **SHOULD** result in an error.

If the JSON string value contains escaped Unicode code points (denoted using
`\u`) they **SHOULD** be interpreted before identifying a prefix.

Encoding to JSON
----------------

When encoding a given value to JSON, the value **MUST** be encoded as specified
in the following table.

| Bencodex type      | JSON type                 |
| ------------------ | ------------------------- |
| Null (`n`)         | Null (`null`)             |
| Boolean (`t`, `f`) | Boolean (`true`, `false`) |
| Byte string        | See [Prefixes](#prefixes) |
| Unicode string     | See [Prefixes](#prefixes) |
| Integer (`i`–`e`)   | See [Prefixes](#prefixes) |
| Lists (`l`–`e`)    | Array (`[]`)              |
| Dictionary         | Object (`{}`)             |

When encoding a dictionary value to a JSON object, the resulting object
**SHOULD** have the same key order as Bencodex specifies.

When encoding a byte string, an implementation **MAY** choose which encoding to
use depending on the length of the value.

Decoding to Bencodex
--------------------

When decoding a given JSON to Bencodex, the duplicate keys of the JSON object
**SHOULD** result in failure of the decoding. In case if this is not desirable,
the implementation **MAY** use the lexically last key-value pair as specified
in [Section 15.12](https://www.ecma-international.org/ecma-262/5.1/ECMA-262.pdf)
("The JSON Object") of ECMAScript 5.1[^ECMAScript].

The ordering of object keys **MUST** be ignored and reordered as Bencodex
specifies.

[^JSON]: Ecma International, "ECMAScript Language Specification,
              5.1 Edition", ECMA Standard 262, June 2011,
              <http://www.ecma-international.org/ecma-262/5.1/ECMA-262.pdf>.
[^RFC-2119]: Bradner, S., "Key words for use in RFCs to Indicate
              Requirement Levels", BCP 14, RFC 2119,
              DOI 10.17487/RFC2119, March 1997,
              <http://www.rfc-editor.org/info/rfc2119>.
[^RFC-4648]: Josefsson, S., "The Base16, Base32, and Base64 Data Encodings",
             RFC 4648, DOI 10.17487/RFC4648, October 2006,
             <https://www.rfc-editor.org/info/rfc4648>.
[^ECMAScript]: Ecma International, "The JSON Data Interchange Format",
              Standard ECMA-404,
              <http://www.ecma-international.org/publications/standards/Ecma-404.htm>.
