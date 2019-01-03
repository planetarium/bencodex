Bencodex Changelog
==================

This repository consists of the specification document and the test suite.
The tests purpose to be confident that an implementation accurately
the specification.  Therefore, although a change of the specification implies
a change of the document and test suite, a change of the document or test suite
does not necessarily imply a change of the specification.

To distinguish these two kinds of changes, this repository follows
the versioning scheme that consists of a *major version* and a *minor version*.
For example, *1.0* represents a major version 1 and a minor version 0.  It is
not a real number, but two positive integers, that is, *1.23* is later than
*1.3*.

If a change breaks compatibility about any cases (even if it's a corner case)
from accurate implementations that follow the specification right before
that change, it increases the major version.

If a change fixes only some typo on the document or adds more test cases,
it does not increase the major version but only the minor version.

In order to an implementation indicates the specification version it follows,
it can mention only a major version.


Version 1.1
-----------

Published on January 4, 2019.

 -  Since YAML is a relatively large and complex specification, only few
    implementations can deal with [`!!binary`][yaml-binary] tag which is many
    YAML files in the Bencodex testsuite uses.  To consider such practical
    reality, JSON files that renders a AST of the corresponding Bencodex value
    were added as an alternative to YAML files.

 -  Since the ordering rule of Unicode keys in a dictionary might be confusing,
    the specifcation became to elaborate about this, a test to check this was
    also added.  [[#1]]

 -  It now has a list of implementations.  It is placed in
    [*LIBRARIES.tsv*](./LIBRARIES.tsv) file.

[yaml-binary]: http://yaml.org/type/binary.html
[#1]: https://github.com/planetarium/bencodex/issues/1


Version 1.0
-----------

Published on November 1, 2018.

This extends the below things on the existing [Bencoding]:

 -  null
 -  Boolean values
 -  Unicode strings besides byte strings
 -  Dictionaries with both byte and Unicode string keys

[Bencoding]: http://www.bittorrent.org/beps/bep_0003.html#bencoding
