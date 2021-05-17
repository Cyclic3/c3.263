#' Opens a directory selection dialog box
#'
#' @return The selected directory, or NULL if cancelled
#' @export
prompt_dir <- tcltk::tk_choose.dir

#' Opens a file selection dialog box
#' 
#' @return The selected file, or NULL if cancelled
#' @export
prompt_file <- tcltk::tk_choose.files

#' Opens a file selection dialog box for common extensions
#'
#' @return The selected file, or NULL if cancelled
#' @export
prompt_datafile <- function() {
  prompt_file(caption="Select data file", multi=F, filters = matrix(c(
    "Data file", ".csv",
    "Data file", ".xlsx",
    "Data file", ".xls",
    "Data file", ".Rds",
    "Data file", ".rds",
    "All files", "*"
  ), 6, 2, byrow=T))
}

#' Reads data directly copied from Mobius
#'
#' @return The loaded data as a dataframe
#' @export
prompt_mobius <- function() {
  print("Paste the data from the Mobius table, followed by an empty line:")
  lines <- list()
  new_part <- NULL
  
  i <- 1
  while ((new_part = readline("% ")) != "") {
    lines[[i]] <- new_part
    i = i + 1
  }
  str = paste(lines, sep="\n")

  utils::read.csv(text=str, sep="\t")
}

#' Load an arbitrary input file
#'
#' This function automatically selects the format based on the extension
#'
#' @param filename Path to the input file
#' @return Data parsed from filename
#' @export
read.data <- function (filename) {
  switch (tools::file_ext(filename),
    "csv" = utils::read.csv(filename),
    "xls" = ,
    "xlsx" = readxl::read_excel(filename),
    "rds" = ,
    "Rds" = base::readRDS(filename)
  )
}
