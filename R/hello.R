#' Hello World Function
#'
#' A simple hello world function to demonstrate the package structure.
#'
#' @param name A character string with a name to greet
#' @return A character string with a greeting
#' @export
#' @examples
#' hello("World")
hello <- function(name = "World") {
  paste("Hello,", name)
}
