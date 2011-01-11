
import test/Builder

tb := static TestBuilder create()

plan: func(num_tests: Int) {
    tb plan(num_tests)
}

no_plan: func {
    tb no_plan()
}

done_testing: func(num_tests: Int) {
    tb done_testing(num_tests)
}

done_testing: func~without_num_tests {
    tb done_testing(tb current_test)
}

skip_all: func(reason: String) {
    tb skip_all(reason)
}

bail_out: func(reason: String) {
    tb bail_out(reason)
}

diag: func(msg: String) {
    tb diag(msg)
}

note: func(msg: String) {
    tb note(msg)
}

todo: func(reason: String, count: Int) {
    tb todo(reason, count)
}

todo: func~without_count(reason: String) {
    tb todo(reason, 1)
}

skip: func(reason: String, count: Int) {
    tb skip(reason, count)
}

skip: func~without_count(reason: String) {
    tb skip(reason, 1)
}

todo_skip: func(reason: String) {
    tb todo_skip(reason)
}

skip_rest: func(reason: String) {
    tb skip_rest(reason)
}

ok: func(test: Bool, name: String) {
    tb ok(test, name)
}

nok: func(test: Bool, name: String) {
    tb ok(! test, name)
}

pass: func(name: String) {
    tb ok(true, name)
}

fail: func(name: String) {
    tb ok(false, name)
}

is: func~Int(got, expected: Int, name: String) {
    pass := got == expected
    tb ok(pass, name)
    if (! pass) {
        tb diag("         got: %d" format(got))
        tb diag("    expected: %d" format(expected))
    }
}

is: func~Double(got, expected: Double, name: String) {
    pass := got == expected
    tb ok(pass, name)
    if (! pass) {
        tb diag("         got: %g" format(got))
        tb diag("    expected: %g" format(expected))
    }
}

is: func~String(got, expected: String, name: String) {
    pass := strcmp(got, expected) == 0
    tb ok(pass, name)
    if (! pass) {
        tb diag("         got: %s" format(got))
        tb diag("    expected: %s" format(expected))
    }
}

isnt: func~Int(got, expected: Int, name: String) {
    pass := got != expected
    tb ok(pass, name)
    if (! pass) {
        tb diag("         got: %d" format(got))
        tb diag("    expected: anything else")
    }
}

isnt: func~Double(got, expected: Double, name: String) {
    pass := got != expected
    tb ok(pass, name)
    if (! pass) {
        tb diag("         got: g" format(got))
        tb diag("    expected: anything else")
    }
}

isnt: func~String(got, expected: String, name: String) {
    pass := strcmp(got, expected) != 0
    tb ok(pass, name)
    if (! pass) {
        tb diag("         got: %s" format(got))
        tb diag("    expected: anything else")
    }
}

isa: func(val: Object, t: Class, name: String) {
    pass := val instanceOf?(t)
    tb ok(pass, name)
    if (! pass)
        tb diag(
            "    isn't a '%s' it's a '%s'" format(t name, val class name)
        )
}

