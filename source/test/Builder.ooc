
TestBuilder: class {
    current_test        : Int { get set }
    _done_testing       : Bool
    expected_tests      : Int
    is_passing          : Bool
    todo_upto           : Int
    todo_reason         : String
    have_plan           : Bool
    no_plan             : Bool
    have_output_plan    : Bool
    output              : FStream { get set }
    failure_output      : FStream { get set }
    todo_output         : FStream { get set }

    init: func {
        current_test = 0
        _done_testing = false
        expected_tests = 0
        is_passing = true
        todo_upto = -1
        todo_reason = null
        have_plan = false
        no_plan = false
        have_output_plan = false
        output = stdout
        failure_output = stderr
        todo_output = stdout
    }

    tb := static null as TestBuilder
    create: static func -> TestBuilder {
        if (tb == null)
            tb = TestBuilder new()
        return tb
    }

    _error: func(msg: String) {
        fputs(msg + "\n", output)
        exit(-1)
    }

    _output: func(msg: String) {
        fputs(msg + "\n", output)
    }

    _comment: func(stream: FStream, msg: String) {
        fputs("# " + msg + "\n", stream)
    }

    _output_plan: func(max: Int, directive, reason: String) {
        out := "1..%d" format(max)
        if (directive && directive length() > 0)
            out += " # " + directive
        if (reason && reason length() >0)
            out += " " + reason
        _output(out)
        have_output_plan = true
    }

    plan: func(num_tests: Int) {
        if (have_plan)
            _error("You tried to plan twice")
        if (num_tests < 0)
            _error(
                "Number of tests must be a positive integer." +
                "  You gave it '%d'." format(num_tests)
            )
        expected_tests = num_tests
        have_plan = true
        _output_plan(num_tests, null, null)
    }

    no_plan: func {
        if (have_plan)
            _error("You tried to plan twice")
        have_plan = true
        no_plan = true
    }

    done_testing: func(num_tests: Int) {
        if (_done_testing) {
            ok(false, "done_testing() was already called")
            return
        }
        _done_testing = true
        if (expected_tests > 0 && num_tests != expected_tests)
            ok(false, "planned to run %d but done_testing() expects %d" format(expected_tests, num_tests))
        else
            expected_tests = num_tests
        if (! have_output_plan)
            _output_plan(num_tests, null, null)
        have_plan = true
        // The wrong number of tests were run
        if (expected_tests != current_test)
            is_passing = false
        // No tests were run
        if (current_test == 0)
            is_passing = false
    }

    skip_all: func(reason: String) {
        if (have_plan)
            _error("You tried to plan twice")
        _output_plan(0, "SKIP", reason)
        exit(0)
    }

    in_todo: func -> Bool {
        return todo_upto >= current_test
    }

    _check_is_passing_plan: func {
        if (no_plan || ! have_plan)
            return
        if (expected_tests < current_test)
            is_passing = false
    }

    ok: func(test: Bool, name: String) {
        if (! have_plan)
            _error("You tried to run a test without a plan")
        current_test += 1
        if (name toInt() != 0) {
            diag("    You named your test '%s'." format(name) +
                    "  You shouldn't use numbers for your test names.")
            diag("    Very confusing.")
        }
        out := test ? "" : "not "
        out += "ok %d" format(current_test)
        if (name && name length() > 0)
            out += " - " + name
        if (todo_reason && in_todo())
            out += " # TODO # " + todo_reason
        _output(out)
        if (! test) {
            msg := "Failed"
            if (in_todo())
                msg += " (TODO)"
                diag("    " + msg + " test (" + __FILE__ + " at line " + __LINE__ toString() + ")")
            diag("    " + msg + " test")
        }
        if (! test && ! in_todo())
            is_passing = false
        _check_is_passing_plan()
    }

    bail_out: func(reason: String) {
        out := "Bail out!"
        if (reason && reason length() > 0)
            out += "  " + reason
        _output(out)
        exit(255)
    }

    todo: func(reason: String, count: Int) {
        todo_upto = current_test + count
        todo_reason = reason
    }

    skip: func(reason: String, count: Int) {
        name := "# skip"
        if (reason && reason length())
            name += " " + reason
        for (i in  0..count)
            ok(true, name)
    }

    todo_skip: func(reason: String) {
        name := "# TODO & SKIP"
        if (reason && reason length())
            name += " " + reason
        ok(false, name)
    }

    skip_rest: func(reason: String) {
        skip(reason, expected_tests - current_test)
    }

    diag: func(msg: String) {
        _comment(in_todo() ? todo_output : failure_output, msg)
    }

    note: func(msg: String) {
        _comment(output, msg)
    }
}
