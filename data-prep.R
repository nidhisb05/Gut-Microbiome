#Ideal Dataset Prep

#Dataset read-in - install and load required packages (tidyverse and readxl)
#library(tidyverse)
#library(readxl)
#read_excel("Probiotics-Academic-Stress.xlsx")

#Name the dataset
#probiotics-stress-dataset <- read_excel("Probiotics-Academic-Stress.xlsx")

#Use dplyr function to filter out "Drop-Out" = 1 - to remove all participants that dropped out and did not complete the study
#im_probiotics_dataset <- probiotics-stress-dataset |>
#filter(`Drop-out`== 0) # Will remove the individuals with "1", only showing participants that remained in the study

#Use dplyr functions to further select, filter and arrange dataset
#Display only the variables required
#im_probiotics_dataset <- probiotics_data |>
  #select(`Participant code`, `Group (enrolment)`, Sex, `Age [years]`, `PSS-10`, `STAI trait`, `Pharmacology examination points`, `Pharmacology examination set`, `Pharmacology pre-examination test`, `State anxiety "at rest"`, `State anxiety "under stress"`, `Salivary cortisol "at rest" [ng/ml]`, `Salivary cortisol "under stress" [ng/ml]`, `Pulse rate "at rest" [min-1]`, `Pulse rate "under stress" [min-1]`, `Salivary 5-HT "at rest" [ng/ml]`, `Salivary 5-HT "under stress" [ng/ml]`) |>
  #print(n=51) # Display all 51 observations

#Change 2 column titles
# * `PSS-10` to `Perceived Stress Scale (PSS-10)` and `STAI trait` too `State-Trait Anxiety Inventory (STAI trait)`*

#Organize by "Salivary cortisol 'under stress'" in ascending order (smallest salivary cortisol level to highest)
# *Use fac_infreq() and then fac_rev() to reverse the current level order*

#Export the created intermediate dataset
#Load readr
#library(readr)
#write_csv(im_probiotics_dataset, file =  "im-probiotics-stress-dataset.csv")

#Lines 22 and 25 - need to figure out what functions to use and how to execute it