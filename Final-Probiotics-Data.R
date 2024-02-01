# Dataset Prep

# Dataset read-in - install and load required packages (tidyverse and readxl)
library(tidyverse)
library(readxl)
read_excel("Probiotics-Academic-Stress.xlsx")

# Name the dataset
probiotics.dataset <- read_excel("Probiotics-Academic-Stress.xlsx")

# Use dplyr functions to further select, filter and arrange dataset
# Display only the variables required
probiotics.stress.data <- probiotics.dataset |>
  filter(`Drop-out`== 0) |>
  rename("Perceived Stress Scale" = "PSS-10", "State-Trait Anxiety Inventory" = "STAI trait", "Age" = "Age [years]", "Exam score" = "Pharmacology examination points", "Pre-examination score" = "Pharmacology pre-examination test", "Group" = "Group (enrolment)") |>
  mutate(`Group`= recode(`Group`, "P" = "Placebo", "S" = "Saccharomyces Boulardii (Probiotic)")) |>
  select(`Participant code`, `Group`, Sex, `Age`, `Perceived Stress Scale`, `State-Trait Anxiety Inventory`, `Exam score`, `Pharmacology examination set`, `Pre-examination score`, `State anxiety "at rest"`, `State anxiety "under stress"`, `Salivary cortisol "at rest" [ng/ml]`, `Salivary cortisol "under stress" [ng/ml]`, `Pulse rate "at rest" [min-1]`, `Pulse rate "under stress" [min-1]`) |>
  arrange(`Group`, `Participant code`)

write_csv(probiotics.stress.data, file =  "final-probiotics-stress-data.csv")

# Check the data types for each column
column_types <- sapply(probiotics.stress.data, class)
print(column_types)

# Boxplot - divided by categories = examination score and treatment groups
# Group by treatments first
# Shape does not work for dot plots - only box plot

ggplot(data = probiotics.stress.data) + geom_boxplot(aes(x = `Group`, y = `Pre-examination score`))

ggplot(data = probiotics.stress.data) + geom_bar(x = `Pre-examination score`)


