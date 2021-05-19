#' Opens a directory selection dialog box
#'
#' @return The selected directory, or NULL if cancelled
prompt_dir <- tcltk::tk_choose.dir

#' Opens a file selection dialog box
#' 
#' @return The selected file, or NULL if cancelled
prompt_file <- tcltk::tk_choose.files

#' Opens a file selection dialog box for common extensions
#'
#' @return The selected file, or NULL if cancelled
prompt_datafile <- function() {
  prompt_file(caption="Select data file", multi=F, filters = matrix(c(
    "Data file", ".csv",
    "Data file", ".xlsx",
    "Data file", ".xls",
    "Data file", ".Rds",
    "Data file", ".RDS",
    "Data file", ".rds",
    "All files", "*"
  ), 7, 2, byrow=T))
}

#' Prompts the user with a question
#'
#' This doesn't put a newline in, so include that if required. This does work in non-interactive mode.
#'
#' @param q The prompt
#' @return The response
prompt_q <- function(q) {
  cat(q)
  readLines("stdin", 1)
}
#' Prints a line, without standard R formatting
#'
#' @param line The line to print
printline <- function (line) {
  cat(line, "\n")
}

#' Reads data directly copied from Mobius
#'
#' @return The loaded data as a dataframe
prompt_mobius <- function() {
  printline("Paste the data from the Mobius table, followed by an empty line:")
  lines <- list()
  new_part <- NULL
  
  # i will be used for indexing the lines
  i <- 1
  # Loop until we read an empty line
  while ((new_part = prompt_q("% ")) != "") {
    # Store the current line at the end of the list
    lines[[i]] <- new_part
    # Prepare for the next line
    i = i + 1
  }
  # Join each line together, with newlines between them
  str = paste(lines, sep="\n")

  # Read it as a csv, but with tabs instead of commas
  utils::read.csv(text=str, sep="\t")
}

#' Asks the user a yes or no question
#'
#' This will loop until we get a valid answer
#'
#' @param q The question
#' @return TRUE on yes, FALSE on no
prompt_yn <- function(q) {
  # Loop until we explicitly ask to stop
  while (T) {
    # Prompt the user
    printline(q)
    line = tolower(prompt_q("y/n: "))
    res <- switch(line, 
      "y" = ,
      "yes" = T,
      "n" = ,
      "no" = F,
      NULL
    )
    # If they actually typed something useful, return it
    if (!is.null(res))
      return(res)
    # Otherwise, whinge
    else
      printline("Please type yes or no!")
  }
}

#' Generates a random lower-case alphanumerical string
#'
#' @param length The length of the generated string
#' @return The generated string
random_alnum <- function (length) {
  arr = c("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9")
  chars = sample(arr, size=length, replace=T);
  paste0(chars, collapse='')
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

#' The internal logic for finding what data the user wants
#'
#' This should not be directly called, as this doesn't include the automatic saving logic
#'
#' @return The data parsed from the user
read.interactive_inner <- function () {
  if (prompt_yn("Do you know the path to the data?"))
    return(read.data(prompt_q("path: ")))
  else if (prompt_yn("Do you want to paste data directly from Mobius?"))
    return(prompt_mobius())
  else if (prompt_yn("Do you want to open a data file?"))
    return(read.data(prompt_datafile()))
  else
    printline("I don't know how to find your data, sorry!")
}

#' Helps the user find the data, and then stores it for easy retrieval later
#'
#' The selected data is stored in an Rds file in the current working directory, with a random filename
#'
#' @return The data parsed from the user
#' @export
read.interactive <- function () {
  data <- read.interactive_inner()
  if (is.null(data))
    return()
  filename <- paste0(random_alnum(), ".Rds")
  base::saveRDS(data, filename)
  # We use an absolute path to ensure that different scripts can use the same code
  printline(sprintf("You can load your data again with c3.263::read.data(\"%s\")", normalizePath(filename)))
  data
}
