
<!-- README.md is generated from README.Rmd. Please edit that file -->

# roxydocs

In order to add documentation to [{cpp11}](https://cpp11.r-lib.org)
wrapper functions, generated using
[`cpp11::cpp_register()`](https://cpp11.r-lib.org/reference/cpp_register.html),
this experimental package adds a
[{roxygen2}](https://roxygen2.r-lib.org) tag, `@documents`, which can be
used to specify one (or several) functions which are associated with an
existing block of documentation.

Mimicking the style of documentation where functions with explicit
`@rdname` tags are associated with a `NULL`-terminated dummy block as

``` r
#' Basic arithmetic
#'
#' @param a,b numeric vectors.
#' @name arith
NULL

#' @rdname arith
add <- function(a, b) a + b

#' @rdname arith
times <- function(a, b) a * b
```

the `@documents` tag attempts to create identical documentation without
having to rely on `@rdname` tags.

``` r
#' Basic arithmetic
#'
#' @param a,b numeric scalars.
#' @name arith
#' @documents add
#' @documents times
NULL

add <- function(a, b) a + b

times <- function(a, b) a * b
```

# Disclaimer

This is not intended for production use, but was only created for
exploring options for documenting [{cpp11}](https://cpp11.r-lib.org)
wrapper functions.
