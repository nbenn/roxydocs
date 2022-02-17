
#' @useDynLib roxydocs, .registration = TRUE
"_PACKAGE"

#' @importFrom roxygen2 roxy_tag_parse
#' @export
roxy_tag_parse.roxy_tag_documents <- function(x) {
  x
}

#' @importFrom roxygen2 roclet_preprocess
#' @export
roclet_preprocess.roclet_rd <- function(x, blocks, base_path) {
  assign("blocks", rewrite_blocks(blocks), envir = parent.frame(2))
  x
}

rewrite_blocks <- function(blocks) {

  todo <- vapply(blocks, has_documents_tag, logical(1L))

  new_blocks <- lapply(blocks[todo], rewrite_block, asNamespace("roxydocs"))
  new_blocks <- unlist(new_blocks, recursive = FALSE, use.names = FALSE)

  append(blocks[!todo], new_blocks)
}

rewrite_block <- function(block, env) {

  todo <- find_documents_tags(block)
  targ <- documents_target(block)

  new_blocks <- lapply(block$tags[todo], create_block, env, targ)

  block$tags <- block$tags[!todo]

  c(list(block), new_blocks)
}

create_block <- function(tag, env, target) {

  name <- tag$raw
  func <- get(name, envir = env)

  srcref <- attr(func, "srcref")

  roxygen2::roxy_block(
    list(documents_to_rdname(tag, target)),
    file = attr(srcref, "srcfile")$filename,
    line = as.vector(srcref)[[1]],
    call = call("<-", as.name(name), func)
  )
}

is_tag <- function(x, tag) identical(x$tag, tag)

find_tags <- function(x, tag) vapply(x$tags, is_tag, logical(1L), tag)

find_documents_tags <- function(x) find_tags(x, "documents")

has_documents_tag <- function(x) any(find_documents_tags(x))

documents_target <- function(x) {
  hit <- find_tags(x, "name")
  x$tags[[which(hit)]]$raw
}

documents_to_rdname <- function(x, targ) {

  x$tag <- "rdname"
  x$raw <- targ

  class(x) <- sub("_documents$", "_rdname", class(x))

  roxy_tag_parse(x)
}
