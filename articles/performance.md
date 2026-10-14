# Performance

``` r

library(S7)
```

The dispatch performance should be roughly on par with S3 and S4, though
as this is implemented in a package there is some overhead due to
`.Call` vs `.Primitive`.

``` r

Text := new_class(parent = class_character)
Number := new_class(parent = class_double)

x <- Text("hi")
y <- Number(1)

foo_S7 := new_generic("x")
method(foo_S7, Text) <- function(x, ...) paste0(x, "-foo")

foo_S3 <- function(x, ...) {
  UseMethod("foo_S3")
}

foo_S3.Text <- function(x, ...) {
  paste0(x, "-foo")
}

library(methods)
setOldClass(c("Number", "numeric", "S7_object"))
setOldClass(c("Text", "character", "S7_object"))

setGeneric("foo_S4", function(x, ...) standardGeneric("foo_S4"))
#> [1] "foo_S4"
setMethod("foo_S4", c("Text"), function(x, ...) paste0(x, "-foo"))

# Measure performance of single dispatch
bench::mark(foo_S7(x), foo_S3(x), foo_S4(x))
#> # A tibble: 3 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 foo_S7(x)    4.71µs   5.46µs   173445.    10.9KB     34.7
#> 2 foo_S3(x)    1.92µs   2.22µs   409026.        0B     40.9
#> 3 foo_S4(x)    2.07µs   2.44µs   393445.        0B     39.3

bar_S7 := new_generic(c("x", "y"))
method(bar_S7, list(Text, Number)) <- function(x, y, ...) paste0(x, "-", y, "-bar")

setGeneric("bar_S4", function(x, y, ...) standardGeneric("bar_S4"))
#> [1] "bar_S4"
setMethod("bar_S4", c("Text", "Number"), function(x, y, ...) paste0(x, "-", y, "-bar"))

# Measure performance of double dispatch
bench::mark(bar_S7(x, y), bar_S4(x, y))
#> # A tibble: 2 × 6
#>   expression        min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>   <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 bar_S7(x, y)   9.73µs  11.02µs    87644.        0B     35.1
#> 2 bar_S4(x, y)   5.39µs   6.25µs   155884.        0B     31.2
```

A potential optimization is caching based on the class names, but lookup
should be fast without this.

The following benchmark generates a class hierarchy of different levels
and lengths of class names and compares the time to dispatch on the
first class in the hierarchy vs the time to dispatch on the last class.

We find that even in very extreme cases (e.g. 100 deep hierarchy 100 of
character class names) the overhead is reasonable, and for more
reasonable cases (e.g. 10 deep hierarchy of 15 character class names)
the overhead is basically negligible.

``` r

library(S7)

gen_character <- function (n, min = 5, max = 25, values = c(letters, LETTERS, 0:9)) {
  lengths <- sample(min:max, replace = TRUE, size = n)
  values <- sample(values, sum(lengths), replace = TRUE)
  starts <- c(1, cumsum(lengths)[-n] + 1)
  ends <- cumsum(lengths)
  mapply(function(start, end) paste0(values[start:end], collapse=""), starts, ends)
}

bench::press(
  num_classes = c(3, 5, 10, 50, 100),
  class_nchar = c(15, 100),
  {
    # Construct a class hierarchy with that number of classes
    Text := new_class(parent = class_character)
    parent <- Text
    classes <- gen_character(num_classes, min = class_nchar, max = class_nchar)
    env <- new.env()
    for (x in classes) {
      assign(x, new_class(x, parent = parent), env)
      parent <- get(x, env)
    }

    # Get the last defined class
    cls <- parent

    # Construct an object of that class
    x <- do.call(cls, list("hi"))

    # Define a generic and a method for the last class (best case scenario)
    foo_S7 := new_generic("x")
    method(foo_S7, cls) <- function(x, ...) paste0(x, "-foo")

    # Define a generic and a method for the first class (worst case scenario)
    foo2_S7 := new_generic("x")
    method(foo2_S7, S7_object) <- function(x, ...) paste0(x, "-foo")

    bench::mark(
      best = foo_S7(x),
      worst = foo2_S7(x)
    )
  }
)
#> # A tibble: 20 × 8
#>    expression num_classes class_nchar      min   median `itr/sec` mem_alloc `gc/sec`
#>    <bch:expr>       <dbl>       <dbl> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#>  1 best                 3          15   4.86µs   5.67µs   171120.        0B     34.2
#>  2 worst                3          15   4.98µs   5.75µs   168683.        0B     33.7
#>  3 best                 5          15   4.78µs   5.59µs   173302.        0B     34.7
#>  4 worst                5          15   5.03µs   5.73µs   169051.        0B     33.8
#>  5 best                10          15   4.89µs   5.64µs   172040.        0B     34.4
#>  6 worst               10          15   5.15µs    5.9µs   164287.        0B     32.9
#>  7 best                50          15      5µs   5.77µs   167706.        0B     33.5
#>  8 worst               50          15    6.3µs   7.02µs   138920.        0B     27.8
#>  9 best               100          15   5.16µs   6.01µs   160781.        0B     32.2
#> 10 worst              100          15   7.77µs   8.56µs   114279.        0B     22.9
#> 11 best                 3         100   4.87µs   5.68µs   170678.        0B     34.1
#> 12 worst                3         100   5.16µs   5.87µs   164471.        0B     32.9
#> 13 best                 5         100   4.89µs   5.66µs   170397.        0B     34.1
#> 14 worst                5         100   5.21µs   5.93µs   162582.        0B     32.5
#> 15 best                10         100    4.9µs   5.67µs   169947.        0B     34.0
#> 16 worst               10         100   5.49µs   6.23µs   153746.        0B     30.8
#> 17 best                50         100   4.95µs   5.74µs   167662.        0B     33.5
#> 18 worst               50         100   8.98µs   9.81µs    99124.        0B     19.8
#> 19 best               100         100   5.28µs   6.03µs   160401.        0B     32.1
#> 20 worst              100         100  13.58µs   14.5µs    67411.        0B     13.5
```

And the same benchmark using double-dispatch

``` r

bench::press(
  num_classes = c(3, 5, 10, 50, 100),
  class_nchar = c(15, 100),
  {
    # Construct a class hierarchy with that number of classes
    Text := new_class(parent = class_character)
    parent <- Text
    classes <- gen_character(num_classes, min = class_nchar, max = class_nchar)
    env <- new.env()
    for (x in classes) {
      assign(x, new_class(x, parent = parent), env)
      parent <- get(x, env)
    }

    # Get the last defined class
    cls <- parent

    # Construct an object of that class
    x <- do.call(cls, list("hi"))
    y <- do.call(cls, list("ho"))

    # Define a generic and a method for the last class (best case scenario)
    foo_S7 := new_generic(c("x", "y"))
    method(foo_S7, list(cls, cls)) <- function(x, y, ...) paste0(x, y, "-foo")

    # Define a generic and a method for the first class (worst case scenario)
    foo2_S7 := new_generic(c("x", "y"))
    method(foo2_S7, list(S7_object, S7_object)) <- function(x, y, ...) paste0(x, y, "-foo")

    bench::mark(
      best = foo_S7(x, y),
      worst = foo2_S7(x, y)
    )
  }
)
#> # A tibble: 20 × 8
#>    expression num_classes class_nchar      min   median `itr/sec` mem_alloc `gc/sec`
#>    <bch:expr>       <dbl>       <dbl> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#>  1 best                 3          15   6.77µs   7.85µs   121898.        0B     36.6
#>  2 worst                3          15      7µs   8.01µs   119982.        0B     36.0
#>  3 best                 5          15   6.76µs   7.85µs   122110.        0B     36.6
#>  4 worst                5          15   7.13µs   8.16µs   117832.        0B     35.4
#>  5 best                10          15   6.75µs   7.85µs   122453.        0B     36.7
#>  6 worst               10          15   7.39µs    8.4µs   114439.        0B     34.3
#>  7 best                50          15   7.17µs   8.27µs   116237.        0B     34.9
#>  8 worst               50          15    9.8µs  10.92µs    88512.        0B     26.6
#>  9 best               100          15    7.5µs    8.6µs   112675.        0B     22.5
#> 10 worst              100          15  12.76µs  13.96µs    69517.        0B     20.9
#> 11 best                 3         100   6.91µs   8.02µs   119526.        0B     23.9
#> 12 worst                3         100   7.57µs   8.61µs   111881.        0B     33.6
#> 13 best                 5         100    6.8µs   7.84µs   122509.        0B     36.8
#> 14 worst                5         100   7.57µs   8.28µs   116263.        0B     34.9
#> 15 best                10         100   6.81µs   7.31µs   133287.        0B     40.0
#> 16 worst               10         100   8.53µs   9.08µs   107692.        0B     32.3
#> 17 best                50         100   7.27µs   7.78µs   125628.        0B     37.7
#> 18 worst               50         100  14.49µs   15.1µs    65018.        0B     19.5
#> 19 best               100         100   7.59µs   8.11µs   120529.        0B     24.1
#> 20 worst              100         100  22.51µs  23.14µs    42553.        0B     12.8
```
