#' Enhanced ggsave with Data Export
#'
#' An enhanced version of ggsave that saves both the plot and exports the underlying
#' data to a compressed table file. Also creates a temporary copy of the plot.
#'
#' @param file Character string. Path where the plot should be saved. Can use glue syntax.
#' @param ... Additional arguments passed to ggsave()
#' @return Invisibly returns the file path
#' @export
#' @examples
#' \dontrun{
#' library(ggplot2)
#' p <- ggplot(mtcars, aes(mpg, wt)) +
#'   geom_point()
#' print(p)
#' mrv_ggsave("my_plot.png")
#' }
mrv_ggsave <- function(file, ...) {
  file <- glue::glue(file)
  print(file)

  ext <- tools::file_ext(file)
  file_without_ext <- tools::file_path_sans_ext(file)
  tbldir <- paste0(dirname(file), "/Tables/")
  tblfile <- paste0(tbldir, basename(file_without_ext), ".tbl.gz")

  # Create Tables directory if it doesn't exist
  if (!dir.exists(tbldir)) {
    dir.create(tbldir, recursive = TRUE)
  }

  # Save the plot
  ggplot2::ggsave(glue::glue("{file}"), bg = "transparent", ...)

  # Copy to temporary file
  cmd <- glue::glue("cp {file} tmp.{ext}")
  print(cmd)
  system(cmd)

  # Save plot data
  data.table::fwrite(ggplot2::last_plot()$data, tblfile, sep = "\t")

  invisible(file)
}

# Global font size setting
FONT_SIZE <- 6

#' Minimal Grid Theme
#'
#' A wrapper for cowplot's theme_minimal_grid with custom font size.
#'
#' @param ... Additional arguments passed to theme_minimal_grid()
#' @return A ggplot2 theme object
#' @export
mrv_grid <- function(...) {
  cowplot::theme_minimal_grid(font_size = FONT_SIZE, ...)
}

#' Minimal Horizontal Grid Theme
#'
#' A wrapper for cowplot's theme_minimal_hgrid with custom font size.
#'
#' @param ... Additional arguments passed to theme_minimal_hgrid()
#' @return A ggplot2 theme object
#' @export
mrv_hgrid <- function(...) {
  cowplot::theme_minimal_hgrid(font_size = FONT_SIZE, ...)
}

#' Minimal Vertical Grid Theme
#'
#' A wrapper for cowplot's theme_minimal_vgrid with custom font size.
#'
#' @param ... Additional arguments passed to theme_minimal_vgrid()
#' @return A ggplot2 theme object
#' @export
mrv_vgrid <- function(...) {
  cowplot::theme_minimal_vgrid(font_size = FONT_SIZE, ...)
}

#' Theme with No X-Axis Elements
#'
#' Removes x-axis title, text, and ticks from a ggplot.
#'
#' @param ... Additional arguments (currently unused)
#' @return A ggplot2 theme object
#' @export
mrv_theme_no_x <- function(...) {
  ggplot2::theme(
    axis.title.x = ggplot2::element_blank(),
    axis.text.x = ggplot2::element_blank(),
    axis.ticks.x = ggplot2::element_blank()
  )
}

#' Reverse Log Transformation
#'
#' Creates a transformation that applies reverse logarithm scaling.
#'
#' @param base Base of the logarithm (default: e)
#' @return A scales transformation object
#' @export
reverselog_trans <- function(base = exp(1)) {
  trans <- function(x) -log(x, base)
  inv <- function(x) base^(-x)
  scales::trans_new(paste0("reverselog-", format(base)), trans, inv,
    scales::log_breaks(base = base),
    domain = c(1e-100, Inf)
  )
}

#' Scientific Notation with Base 10
#'
#' Formats numbers in scientific notation with proper base-10 expressions.
#'
#' @param x Numeric vector to format
#' @return Expression vector for plotting
#' @export
scientific_10 <- function(x) {
  is_one <- as.numeric(x) == 1
  text <- gsub("e", " %*% 10^", scales::scientific_format()(x))
  text <- stringr::str_remove(text, "^1 %\\*% ") # remove leading one
  text[is_one] <- "10^0"
  rtn <- parse(text = text)
  rtn
}

#' Logit Transformation with Exponential Base
#'
#' Applies logit transformation using exponential base.
#'
#' @param x Input values
#' @param a Scale parameter (default: 1)
#' @param b Shift parameter (default: 0)
#' @return Transformed values
#' @export
logit_e <- function(x, a = 1, b = 0) {
  z <- x^exp(1)
  log(z / (1 - z))
}

#' Anti-Logit Transformation with Exponential Base
#'
#' Inverse of logit_e transformation.
#'
#' @param x Input values
#' @param a Scale parameter (default: 1)
#' @param b Shift parameter (default: 0)
#' @return Transformed values
#' @export
anti_logit_e <- function(x, a = 1, b = 0) {
  z <- exp(b) * x^a
  (z / (1 + z))^exp(-1)
}

#' Anti-Logit Transformation Object
#'
#' A scales transformation object for anti-logit with exponential base.
#'
#' @export
trans_anti_logit_e <- scales::trans_new(
  name      = "trans_anti_logit_e",
  transform = anti_logit_e,
  inverse   = logit_e
)
