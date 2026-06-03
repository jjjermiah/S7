# Performance

``` r

library(S7)
```

The dispatch performance should be roughly on par with S3 and S4, though
as this is implemented in a package there is some overhead due to
`.Call` vs `.Primitive`.

``` r

Text <- new_class("Text", parent = class_character)
Number <- new_class("Number", parent = class_double)

x <- Text("hi")
y <- Number(1)

foo_S7 <- new_generic("foo_S7", "x")
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
#> 1 foo_S7(x)    7.23µs   8.98µs   103803.    10.8KB     20.8
#> 2 foo_S3(x)    2.52µs   2.95µs   307776.        0B      0  
#> 3 foo_S4(x)    2.71µs   3.31µs   288054.        0B     28.8

bar_S7 <- new_generic("bar_S7", c("x", "y"))
method(bar_S7, list(Text, Number)) <- function(x, y, ...) paste0(x, "-", y, "-bar")

setGeneric("bar_S4", function(x, y, ...) standardGeneric("bar_S4"))
#> [1] "bar_S4"
setMethod("bar_S4", c("Text", "Number"), function(x, y, ...) paste0(x, "-", y, "-bar"))

# Measure performance of double dispatch
bench::mark(bar_S7(x, y), bar_S4(x, y))
#> # A tibble: 2 × 6
#>   expression        min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>   <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 bar_S7(x, y)     13µs  15.47µs    62705.        0B     18.8
#> 2 bar_S4(x, y)   6.89µs   8.14µs   118759.        0B     23.8
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
    Text <- new_class("Text", parent = class_character)
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
    foo_S7 <- new_generic("foo_S7", "x")
    method(foo_S7, cls) <- function(x, ...) paste0(x, "-foo")

    # Define a generic and a method for the first class (worst case scenario)
    foo2_S7 <- new_generic("foo2_S7", "x")
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
#>  1 best                 3          15   7.41µs   9.19µs   105273.        0B     21.1
#>  2 worst                3          15   7.64µs   9.44µs   101843.        0B     30.6
#>  3 best                 5          15   7.38µs   9.32µs   103205.        0B     31.0
#>  4 worst                5          15   7.66µs   9.47µs   101894.        0B     30.6
#>  5 best                10          15   7.59µs   9.34µs   103449.        0B     31.0
#>  6 worst               10          15   7.89µs   9.76µs    99357.        0B     19.9
#>  7 best                50          15   7.89µs   9.87µs    97637.        0B     29.3
#>  8 worst               50          15   9.64µs  11.57µs    82878.        0B     24.9
#>  9 best               100          15   8.64µs  10.57µs    90806.        0B     27.3
#> 10 worst              100          15  11.93µs  13.98µs    69331.        0B     20.8
#> 11 best                 3         100   7.51µs   9.39µs   102335.        0B     30.7
#> 12 worst                3         100   7.91µs   9.79µs    98037.        0B     29.4
#> 13 best                 5         100   7.54µs    9.5µs   101065.        0B     30.3
#> 14 worst                5         100   7.95µs   9.95µs    95876.        0B     19.2
#> 15 best                10         100   7.68µs   9.76µs    96796.        0B     19.4
#> 16 worst               10         100   8.34µs  10.43µs    90883.        0B     27.3
#> 17 best                50         100   8.06µs  10.11µs    93846.        0B     28.2
#> 18 worst               50         100  13.19µs  15.27µs    63182.        0B     12.6
#> 19 best               100         100   8.72µs  10.87µs    87401.        0B     26.2
#> 20 worst              100         100  19.46µs  21.71µs    44476.        0B     13.3
```

And the same benchmark using double-dispatch

``` r

bench::press(
  num_classes = c(3, 5, 10, 50, 100),
  class_nchar = c(15, 100),
  {
    # Construct a class hierarchy with that number of classes
    Text <- new_class("Text", parent = class_character)
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
    foo_S7 <- new_generic("foo_S7", c("x", "y"))
    method(foo_S7, list(cls, cls)) <- function(x, y, ...) paste0(x, y, "-foo")

    # Define a generic and a method for the first class (worst case scenario)
    foo2_S7 <- new_generic("foo2_S7", c("x", "y"))
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
#>  1 best                 3          15   8.87µs   11.6µs    80914.        0B    24.3 
#>  2 worst                3          15   9.26µs   11.8µs    79689.        0B    31.9 
#>  3 best                 5          15   9.32µs   11.7µs    81201.        0B    32.5 
#>  4 worst                5          15   9.82µs   12.3µs    77380.        0B    23.2 
#>  5 best                10          15   9.49µs   11.8µs    79416.        0B    31.8 
#>  6 worst               10          15    9.9µs   11.5µs    82406.        0B    24.7 
#>  7 best                50          15  10.32µs   11.3µs    86204.        0B    34.5 
#>  8 worst               50          15  13.61µs   14.6µs    66906.        0B    26.8 
#>  9 best               100          15  11.46µs   12.6µs    77519.        0B    38.8 
#> 10 worst              100          15  18.05µs   19.8µs    48600.        0B    19.4 
#> 11 best                 3         100   9.57µs   11.3µs    84143.        0B    25.3 
#> 12 worst                3         100  10.41µs   12.2µs    78201.        0B    31.3 
#> 13 best                 5         100   9.39µs   11.1µs    85894.        0B    25.8 
#> 14 worst                5         100  10.47µs   12.4µs    76766.        0B    30.7 
#> 15 best                10         100   9.59µs   11.5µs    82620.        0B    24.8 
#> 16 worst               10         100  11.69µs   13.8µs    68806.        0B    27.5 
#> 17 best                50         100  10.73µs   12.6µs    75377.        0B    30.2 
#> 18 worst               50         100   20.2µs   22.1µs    43664.        0B    13.1 
#> 19 best               100         100     12µs   13.6µs    70515.        0B    28.2 
#> 20 worst              100         100  31.26µs   33.2µs    29333.        0B     8.80
```
