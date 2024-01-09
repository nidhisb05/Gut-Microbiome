## Loading tidyverse and papaja packages
options(repos = c(CRAN = "https://cran.rstudio.com"))
library(tidyverse)

install.packages("tinylabels")
library(tinylabels)

install.packages("tinytex")
library(tinytex)

install.packages("papaja")
library(papaja)

# Require other package, installed ggplot2
install.packages("ggplot2")
require("ggplot2")

# Assigning numeric variables
numeric_variable <- 25
print(numeric_variable)

numeric_variable2 <- 5
print(numeric_variable2)

# Assigning string/character variables
string_variable <- "gut microbiome"
print(string_variable)

string_variable2 <- "sepsis data"
print(string_variable2)

string_variable3 <- "uploaded dataset"
print(string_variable3)
