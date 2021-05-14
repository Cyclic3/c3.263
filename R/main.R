#' @export
prompt_dir <- tcltk::tk_choose.dir

#' @export
prompt_file <- tcltk::tk_choose.files

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

  read.csv(text=str, sep="\t")
}

#' @export
read.data <- function (filename) {
  switch (tools::file_ext(filename),
    "csv" = read.csv(filename),
    "xls" = ,
    "xlsx" = readxl::read_excel(filename),
    "rds" = ,
    "Rds" = readRDS(filename)
  )
}
