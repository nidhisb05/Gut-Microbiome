library(tidyverse)
library(readr)
## Create your goal tibble to replicate

# Run this line to see what your end product should look like
sw.wrangled.goal <- read.csv("sw-wrangled.csv") %>% 
  mutate(across(c(hair, gender, species, homeworld), factor)) # this is a quick-and-dirty fix to account for odd importing behavior

# View in console
sw.wrangled.goal 

# Examine the structure of the df and take note of data types
# Look closely at factors (you may need another function to do so) to see their levels
str(sw.wrangled.goal) 

## Use the built-in starwars dataset to replicate the tibble above in a tbl called sw.wrangled
# If you get stuck, use comments to "hold space" for where you know code needs to go to achieve a goal you're not sure how to execute
sw.wrangled <- starwars %>%
  separate(name, c("first_name", "last_name"), sep = " ", extra = "merge", remove = FALSE) %>% # Splitting the "name" column into "first" and "last" name columns, missing fields replaced with "NA"
  mutate(FirstName_Character = substr(first_name, 1, 1)) %>% # Creating first name initial
  mutate(LastName_Character = substr(last_name, 1, 1)) %>% # Creating last name initial
  unite(initials, FirstName_Character:LastName_Character, sep = "") %>% # Joining the two initials and creating "initials" column
  mutate(height_in = height * 0.39370) %>% # Multiply cm height by 0.393701 to get height in inches and create "height_in" column
  rename(height_cm = height) %>% # Renaming "height" to "height_cm"
  rename(hair = hair_color) %>% # Renaming "hair_color" to "hair"
  mutate(hair = ifelse(is.na(hair), "bald", hair)) %>% # Replacing all hair "NA" with "bald" in the hair column
  mutate(gender = substr(gender, 1, 1)) %>% # Selecting only gender initial "m" or "f"
  mutate(species = toupper(species)) %>% # Changing all species names to upper case
  mutate(brown_hair = str_detect(hair, "brown")) %>% # Checks for brown hair and indicates "T/F"
  arrange(last_name, first_name) %>% # Arranging rows by "last name" and then "first name" if same last name appears
  filter(!is.na(height_in)) %>% # Remove names that have height_in of "NA"
  select(first_name, last_name, initials, height_in, height_cm, mass, hair, gender, species, homeworld, brown_hair) # Selecting the required columns
  

## Check that your sw.wrangled df is identical to the goal df
# Use any returned information about mismatches to adjust your code as needed
all.equal(sw.wrangled.goal, sw.wrangled)
# Received 4 mismatches in columns "hair", "gender", "species" and "homeworld" component "levels"/"factor"
# Received 2 mismatches for component "class"
# Need to understand how to use factor() and levels() to address this
