
import text/Regexp

import test/More

plan(5)

rx := Regexp compile("a+b")
isa(rx, Regexp, "is a Regexp")

isa(rx matches("aaabc"), Match, "is a Match")
ok(rx matches("aaacc") == null, "no match")

num := Regexp compile("([0-9]+)")
result := num matches("ab12cd")
isa(result, Match, "is a Match")
is(result group(1), "12", "capture")
