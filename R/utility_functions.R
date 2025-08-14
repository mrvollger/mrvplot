#' Read BED File with Standardized Column Names
#'
#' Reads a BED file and standardizes column names, sorting by genomic position.
#'
#' @param ... Arguments passed to data.table::fread()
#' @return A data.table with standardized BED format columns
#' @export
mrv_read_bed <- function(...) {
  df <- data.table::fread(...)
  names <- colnames(df)
  names[names == "start"] <- "start.other"
  names[names == "end"] <- "end.other"
  names[1:3] <- c("chrom", "start", "end")
  colnames(df) <- names
  # sort by chrom then start then end
  df <- df[order(df$chrom, df$start, df$end)]
  df
}
