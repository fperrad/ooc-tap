
"1..6" println()

if (true)
    "ok 1" println()
else
    "not ok 1" println()

if (! true)
    "not ok 2" println()
else
    "ok 2" println()

a := 12
b := 34
if (a < b)
    "ok 3" println()
else
    "not ok 3" println()

a = 0
b = 4
if (a < b)
    "ok 4" println()
else if (a == b)
    "not ok 4" println()
else
    "not ok 4" println()

a = 5
b = 5
if (a < b)
    "not ok 5" println()
else if (a == b)
    "ok 5" println()
else
    "not ok 5" println()

a = 10
b = 6
if (a < b)
    "not ok 6" println()
else if (a == b)
    "not ok 6" println()
else
    "ok 6" println()
