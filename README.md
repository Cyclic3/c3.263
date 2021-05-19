# c3.263

## DISCLAIMER
I hacked this together in a couple of hours, so there is a definite possibility that this thing suddenly
breaks in the middle of the exam. Always check that the loaded data matches what you expect!

## Installation
Simply run `devtools::install_github("Cyclic3/c3.263")` from an R console. You may get a warning about Rtools
not being installed, which can be safely ignored.

## Usage
```R
# The read.interactive function will walk you through loading your data
#
# You can choose to run the function like this:
library(c3.263)
x <- read.interactive()
# Or like this:
y <- c3.263::read.interactive()

# After you load data in this way, it will give you some code you can paste to instantly load it again,
# without having to follow through the prompts
#
# The line below IS AN EXAMPLE, and will not work on your machine
z <- c3.263::read.data("C:\09f911029d74e35bd84156c5635688c0.Rds")
```
