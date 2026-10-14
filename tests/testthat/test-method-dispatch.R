test_that("single dispatch works for specials", {
  foo := new_generic("x")

  method(foo, class_any) <- function(x) "fallback"
  expect_equal(foo(), "fallback")
  expect_equal(foo(1), "fallback")

  method(foo, class_missing) <- function(x) "missing"
  expect_equal(foo(), "missing")
})

test_that("single dispatch evaluates defaults and preserves promises", {
  foo := new_generic("x", function(x = NULL, ...) S7_dispatch())
  method(foo, NULL) <- function(x, ...) list(x, substitute(x))
  method(foo, class_missing) <- function(x, ...) "missing"

  expect_identical(foo(), list(NULL, NULL))
  expect_identical(foo(x = ), list(NULL, NULL))
  expect_identical(foo(identity(NULL)), list(NULL, quote(identity(NULL))))

  forward <- function(x) foo(x)
  expect_identical(forward(), "missing")
  expect_identical(forward(NULL), list(NULL, quote(x)))

  forced := new_generic("x", function(x = NULL, ...) {
    force(x)
    S7_dispatch()
  })
  method(forced, NULL) <- function(x, ...) substitute(x)
  expect_null(forced())
})

test_that("multiple dispatch evaluates dependent defaults once", {
  calls <- 0L
  calendar <- function(x) {
    calls <<- calls + 1L
    paste0("calendar:", x)
  }
  foo := new_generic(c("x", "cal"), function(x, cal = calendar(x), ...) {
    S7_dispatch()
  })
  method(foo, list(class_double, class_character)) <- function(x, cal, ...) {
    list(x, cal, substitute(x), substitute(cal))
  }
  method(foo, list(class_missing, class_missing)) <- function(x, cal, ...) {
    c(missing(x), missing(cal))
  }

  expect_identical(
    foo(identity(1)),
    list(1, "calendar:1", quote(identity(1)), quote(calendar(x)))
  )
  expect_identical(calls, 1L)
  expect_identical(foo(1, "explicit"), list(1, "explicit", 1, "explicit"))
  forward <- function(x, cal) foo(x, cal)
  expect_identical(forward(), c(TRUE, TRUE))
})

test_that("lookup errors describe default values", {
  foo := new_generic("x", function(x = NULL) S7_dispatch())
  expect_snapshot(foo(), error = TRUE)
})

test_that("single dispatch works for base types", {
  foo := new_generic("x")

  method(foo, class_character) <- function(x) "base"

  expect_equal(foo("bar"), "base")
})

test_that("single dispatch works for S7 objects", {
  foo := new_generic("x")

  text := new_class(class_character)
  method(foo, text) <- function(x) "S7"

  expect_equal(foo(text("bar")), "S7")
})

test_that("single dispatch works for S3 objects", {
  foo := new_generic("x")

  obj <- structure("hi", class = "my_S3")
  method(foo, new_S3_class("my_S3")) <- function(x) "S3"

  expect_equal(foo(obj), "S3")
})

test_that("single dispatch works for S4 objects", {
  local_S4_classes()
  foo := new_generic("x")

  my_S4 <- setClass("my_S4", contains = "numeric")
  method(foo, my_S4) <- function(x) "S4"

  expect_equal(foo(my_S4(1)), "S4")
})

test_that("single dispatch works for unions", {
  foo := new_generic("x")

  method(foo, new_union(class_integer, class_logical)) <- function(x) "union"

  expect_equal(foo(TRUE), "union")
  expect_equal(foo(1L), "union")
})

test_that("multiple dispatch works", {
  foo1 := new_class()
  foo2 := new_class(foo1)

  bar := new_generic(c("x", "y"))
  method(bar, list(foo1, foo1)) <- function(x, y) c(1, 1)
  method(bar, list(foo2, foo2)) <- function(x, y) c(2, 2)

  expect_equal(bar(foo1(), foo1()), c(1, 1))
  expect_equal(bar(foo1(), foo2()), c(1, 1))
  expect_equal(bar(foo2(), foo1()), c(1, 1))
  expect_equal(bar(foo2(), foo2()), c(2, 2))
})


test_that("can substitute() args", {
  foo := new_generic("x", function(x, ..., z = 1) S7_dispatch())
  method(foo, class_character) <- function(x, ..., z = 1) substitute(x)
  expect_equal(foo(letters), quote(letters))

  suppressMessages(
    method(foo, class_character) <- function(x, ..., z = 1, y) substitute(y)
  )
  expect_equal(foo("x", y = letters), quote(letters))

  suppressMessages(
    method(foo, class_character) <- function(x, ..., z = 1) substitute(z)
  )
  expect_equal(foo("x", z = letters), quote(letters))

  suppressMessages(
    method(foo, class_character) <- function(x, ..., z = 1) {
      substitute(list(...))
    }
  )
  expect_equal(foo("x", abc = xyz), quote(list(abc = xyz)))

  suppressMessages(
    method(foo, class_character) <- function(x, ..., z = 1, y) missing(y)
  )
  expect_true(foo("x"), TRUE)
  expect_true(foo("x", y = ), TRUE)
  expect_true(foo("x", y = ), TRUE)

  suppressMessages(
    method(foo, class_character) <- function(x, ..., z = 1, y) ...length()
  )

  expect_equal(foo("x"), 0)
  expect_equal(foo("x", y = ), 0)
  expect_equal(foo("x", y = , abc), 1)
  expect_equal(foo("x", y = , abc = xyz), 1)
  expect_equal(foo("x", y = , abc, xyz), 2)
})

test_that("methods get values modified in the generic", {
  foo := new_generic("x", function(x, y = 1) {
    y <- 10
    S7_dispatch()
  })
  method(foo, class_character) <- function(x, y = 1) y
  expect_equal(foo("x", 1), 10)
})

test_that("dispatched arguments are evaluated once", {
  counter <- local({
    i <- 0
    function() {
      i <<- i + 1
      i
    }
  })

  f := new_generic("x")
  method(f, class_double) <- function(x) x
  expect_equal(f(counter()), 1)
})

test_that("generics pass ... to methods", {
  foo := new_generic("x")

  method(foo, class_character) <- function(x, y = 1) y
  expect_equal(foo("x"), 1)
  expect_equal(foo("x", y = 2), 2)
  expect_snapshot_error(foo("x", z = 2))
})

test_that("generics pass extra args to methods", {
  foo := new_generic("x", function(x, ..., z = 1) S7_dispatch())
  method(foo, class_character) <- function(x, ..., z = 1) z
  expect_equal(foo("x", z = 3), 3)
})

test_that("can dispatch on base 'union' types", {
  foo := new_generic("x")
  suppressMessages({
    method(foo, class_vector) <- function(x) "v"
    method(foo, class_atomic) <- function(x) "a"
    method(foo, class_numeric) <- function(x) "n"
    method(foo, class_integer) <- function(x) "i"
  })

  expect_equal(foo(list()), "v")
  expect_equal(foo(character()), "a")
  expect_equal(foo(double()), "n")
  expect_equal(foo(integer()), "i")
})

test_that("single dispatch fails with informative messages", {
  local_S4_classes()
  fail := new_generic("x")

  foo := new_class(package = NULL)
  Foo <- setClass("Foo", slots = list("x" = "numeric"))

  expect_snapshot(error = TRUE, {
    fail(TRUE)
    fail(tibble::tibble())
    fail(foo())
    fail(Foo(x = 1))
  })

  expect_error(fail(TRUE), class = "S7_error_method_not_found")
})

test_that("multiple dispatch fails with informative messages", {
  local_S4_classes()
  fail := new_generic(c("x", "y"))

  foo := new_class()
  Foo <- setClass("Foo", slots = list("x" = "numeric"))

  expect_snapshot(error = TRUE, {
    fail(TRUE)
    fail(, TRUE)
    fail(TRUE, TRUE)
  })

  expect_error(fail(TRUE, TRUE), class = "S7_error_method_not_found")
})

test_that("dispatch fails cleanly when generic is not an S7 generic", {
  f <- function() S7_dispatch()
  expect_snapshot(f(), error = TRUE)
})

test_that("S7_error_method_not_found error class is not duplicated", {
  fail := new_generic("x")
  cnd <- tryCatch(fail(TRUE), S7_error_method_not_found = identity)
  expect_s3_class(
    cnd,
    c("S7_error_method_not_found", "error", "condition"),
    exact = TRUE
  )
})

test_that("method dispatch preserves method return visibility", {
  foo := new_generic("x")
  method(foo, class_integer) <- function(x) invisible("bar")
  expect_invisible(foo(1L))

  method(foo, class_character) <- function(x) {
    if (x == "nope") {
      return(invisible("bar"))
    }
    "bar"
  }

  expect_visible(foo("yep"))
  expect_invisible(foo("nope"))
})

test_that("can dispatch on evaluated arguments", {
  my_generic := new_generic("x", function(x) {
    x <- 10
    S7_dispatch()
  })
  method(my_generic, class_numeric) <- function(x) 100
  expect_equal(my_generic("x"), 100)
})


test_that("method dispatch works for class_missing", {
  foo := new_generic("x")
  method(foo, class_missing) <- function(x) missing(x)
  method(foo, class_any) <- function(x) FALSE

  expect_true(foo())
  expect_false(foo(1))

  # even when forwarded (#595)
  foo_wrapper <- function(x) foo(x)
  expect_true(foo_wrapper())
  expect_false(foo_wrapper(1))
})

test_that("errors from dispatched methods have reasonable tracebacks", {
  get_call_stack <- function(n = 3) {
    x <- sys.calls()
    x <- x[-length(x)] # remove get_call_stack()
    x <- tail(x, n)
    lapply(x, utils::removeSource)
  }

  my_generic := new_generic("x")
  method(my_generic, class_numeric) <- function(x) get_call_stack()
  expect_snapshot(my_generic(10))

  my_generic := new_generic(c("x", "y"))
  method(my_generic, list(class_numeric, class_numeric)) <-
    function(x, y) get_call_stack()
  expect_snapshot(my_generic(3, 4))
})

test_that("the call of a dispatched method can be deparsed (#783)", {
  skip_if_not_installed("rlang")

  Foo <- new_class("Foo", package = NULL)
  Bar <- new_class("Bar", Foo, package = NULL)
  # `z` is not used for dispatch; the dispatch arguments are S7 objects, which
  # deparse() can't print on older versions of R.
  foo := new_generic(c("x", "y"), function(x, y, ..., z = 1) S7_dispatch())
  method(foo, list(Foo, Foo)) <- function(x, y, ..., z = 1) stop("boom")

  get_call <- function(code) conditionCall(tryCatch(code, error = identity))
  expected <- "`method(foo, list(Foo, Foo))`(...)"

  expect_identical(deparse1(get_call(foo(Foo(), Foo()))), expected)
  expect_identical(deparse1(get_call(foo(Foo(), Foo(), 1, z = 2))), expected)
  expect_identical(rlang::as_label(get_call(foo(Foo(), Foo()))), expected)
  expect_identical(
    rlang::as_label(get_call(foo(Foo(), Foo(), 1, z = Foo()))),
    expected
  )

  # super() inlines the S7 value in the method call
  expect_identical(
    deparse1(get_call(foo(super(Bar(), Foo), Foo()))),
    expected
  )
  expect_identical(
    rlang::as_label(get_call(foo(Foo(), super(Bar(), Foo), z = Foo()))),
    expected
  )
})

test_that("dispatching through `...` preserves method arguments", {
  Foo <- new_class("Foo")
  foo := new_generic(c("x", "y"), function(x, y, ..., z = x) S7_dispatch())
  method(foo, list(Foo, class_numeric)) <- function(x, y, ..., z = x) {
    list(
      substitute(x),
      substitute(y),
      substitute(z),
      substitute(list(...)),
      names(list(...)),
      missing(z),
      nargs()
    )
  }
  x <- Foo()
  nn <- 3
  forward <- function(obj, n, ...) foo(obj, n, ...)

  expect_identical(
    foo(x, 1 + 2, k = 3, 4 * 5, z = x),
    list(
      quote(x),
      quote(1 + 2),
      quote(x),
      quote(list(k = 3, 4 * 5)),
      c("k", ""),
      FALSE,
      5L
    )
  )
  expect_identical(
    forward(x, nn, a = 1)[c(1, 2, 4)],
    list(quote(obj), quote(n), quote(list(a = 1)))
  )
  expect_identical(foo(x, 1)[c(3, 6)], list(quote(x), FALSE))

  # The generic's own `...` is restored after dispatching
  bar := new_generic("x", function(x, ...) {
    res <- S7_dispatch()
    list(res, ...length(), names(list(...)))
  })
  method(bar, class_numeric) <- function(x, ...) ...length()
  expect_identical(bar(1, 2, a = 3), list(2L, 2L, c("", "a")))
  expect_identical(bar(1), list(0L, 0L, NULL))
})
