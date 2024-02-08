library(tidyverse)

## Create your goal tibble to replicate

# # Run this line to see what your end product should look like
# sw.wrangled.goal <- read_csv("data/sw-wrangled.csv") %>% 
#   mutate(across(c(hair, gender, species, homeworld), factor)) # this is a quick-and-dirty fix to account for odd importing behavior
# 
# # View in console
# sw.wrangled.goal 
# 
# # Examine the structure of the df and take note of data types
# # Look closely at factors (you may need another function to do so) to see their levels
# str(sw.wrangled.goal) 
# 
# 
# 
# ## Use the built-in starwars dataset to replicate the tibble above in a tbl called sw.wrangled
# # If you get stuck, use comments to "hold space" for where you know code needs to go to achieve a goal you're not sure how to execute
# sw.wranged <- starwars # %>% ...
# 
# 
# 
# ## Check that your sw.wrangled df is identical to the goal df
# # Use any returned information about mismatches to adjust your code as needed
# all.equal(sw.wrangled.goal, sw.wrangled.goal)


sw.wrangled <- starwars %>% 
  # Select only needed columns & rename height (to height_cm) and hair_color (to hair)
  select(name, height_cm = height, mass, hair = hair_color, gender, species, homeworld) %>% 
  # Filter out any rows where height data is missing
  filter(!is.na(height_cm)) %>% 
  # Break names into two columns (first_name, last_name); use first space " " as delimiter
  ## too_many="merge": if more than one delim (space) is found, merge everything after the space into the second column
  ## too_few="align_start": if less than one delim is found, treat the name like a first name and make last_name NA
  ## notice where in the column order the new columns appear vs if you did this with a mutate 
  separate_wider_delim(name, delim=" ", names = c("first_name", "last_name"), too_many="merge", too_few = "align_start") %>% 
  # Change categorical variables to factors
  mutate(
    ## for the 2 detected levels of gender (feminine, masculine) relabel (i.e., rename/replace those values) with f & m
    gender = factor(gender, levels = c("feminine", "masculine"), labels = c("f", "m")),
    ## convert character values in species to all upper case before creating factor levels
    species = factor(str_to_upper(species)),
    homeworld = factor(homeworld)) %>% 
  # create a second height column by converting cm to inches
  mutate(height_in = height_cm*.3937) %>% 
  # where there is no value in hair, use value "bald"
  mutate(hair = factor(replace_na(hair, "bald"))) %>% 
  # create a logical variable that returns true if "brown" is anywhere in the string value for hair 
  mutate(brown_hair = str_detect(hair, "brown")) %>% 
  # create an initials column by concatenating the first characters of the first and last name
  ## str_sub(colname, 1, 1) -- the '1,1' bit means the first character to include is the one in position 1
  ## and the last is in position 1 (so just the first character)
  mutate(initials = paste0(str_sub(first_name, 1, 1), str_sub(last_name, 1, 1))) %>% 
  # move the new height_in column to be immediately left of the height_cm column 
  relocate(height_in, .before = height_cm) %>% 
  # move the new initials column to be immediately right of the last_name column
  relocate(initials, .after = last_name) %>% 
  # sort by last_name and then (when last_name matches) by first_name
  arrange(last_name, first_name)

#write_csv(sw.wrangled, "data/sw-wrangled.csv")

# Plot 1 - height_cm and count
library(tidyverse)
ggplot(data = sw.wrangled) + geom_histogram(aes(x = height_cm), binwidth = 10) # This binwidth matches the example plot1 image

# Plot 2 - sorted_hair and count
# Need to reorder the levels of hair based on count - largest to smallest
sw.wrangled$hair <- factor(sw.wrangled$hair, levels = names(sort(table(sw.wrangled$hair), decreasing = TRUE)))
# Bar plot - make sure hair is organized from largest to smallest count
ggplot(data = sw.wrangled) + geom_bar(aes(x = hair))

# Plot 3 - height_in and mass
sw.wrangled %>%
  ggplot(aes(x = height_in, y = mass)) +
  geom_point(sw.wrangled = subset(sw.wrangled, mass <= 160), shape = "triangle") +  # Exclude the outlier by indicating the y-axis limit
  coord_cartesian(xlim = c(25, 93), ylim = c(15, 160)) +  # Set the axis limits
  scale_x_continuous(breaks = seq(40, 80, by = 20)) +  # Set x-axis breaks
  scale_y_continuous(breaks = seq(40, 160, by = 40))  # Set y-axis breaks



# Assignment 12
# Plot 1 - sorted_hair and count in boxplot with diff colors
library(tidyverse)
sw.wrangled$hair <- factor(sw.wrangled$hair, levels = names(sort(table(sw.wrangled$hair), decreasing = TRUE)))

sw.wrangled %>%
  ggplot(aes(x = hair, y = mass, fill = hair)) +
  geom_boxplot(sw.wrangled = subset(sw.wrangled, mass <= 160)) +
  coord_cartesian(ylim = c(15,160)) +
  scale_y_continuous(breaks = seq(40,160, by = 40)) +
  geom_point(aes(x = hair, y = mass)) +
  labs(x = "Hair color(s)",
       y = "Mass (kg)",
       fill = "Colorful Hair") + # Change legend title
  guides(fill = guide_legend(override.aes = list(shape = NA))) 


# Plot 2 - mass vs. height by brown-hair-havingness
library(tidyverse)
sw.wrangled$brown_hair <- factor(sw.wrangled$brown_hair, levels = c(TRUE, FALSE))
  
sw.wrangled %>%
  filter(!(mass > 1000)) %>% # To remove the outlier
  arrange(brown_hair) %>%
  ggplot(aes(x = `mass`, y = `height_in`)) +
  geom_point() +
  coord_cartesian(xlim = c(-200,200), ylim = c(-4,150)) + # Setting the axes
  facet_wrap(~ brown_hair, labeller = labeller(brown_hair = c('TRUE' = "Has brown hair", 'FALSE' = "No brown hair"))) + # Display the brown hair and no brown hair data side by side
  geom_smooth(method = "lm") + # Using the formula 'y ~ x' to calculate a line of best fit
  scale_y_continuous(breaks = c(-4,20,23, 80, 100)) + # Choosing the accurate axis breaks
  labs(title = "Mass vs. Height by Brown-Hair-Havingness",
        subtitle = "A critically important analysis",
        x = "mass",
        y = "height_in")


# Plot 3 - stacked bar graph based on species count of first alphabet
library(tidyverse)
sw.wrangled.plot3 <- sw.wrangled %>%
  filter(!is.na(gender)) %>%
  mutate(species_firstchar = substr(species, 1, 1)) %>%
  group_by(gender, species_firstchar) %>%
  summarise(Count = n())

sw.wrangled.plot3 %>%
  ggplot(aes(x = Count, y = species_firstchar, fill = gender)) +
  geom_col(position = "stack") +
  theme(panel.background = element_rect(fill = "white", color = "white"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.line = element_line(color = "black")) + # To set the background as white, remove any grid lines, and make sure axis is black
  labs(x = "count",
       y = "species_first_letter",
       caption = "A clear male human bias") +
  scale_fill_manual(values = c("m" = "#54B6BC", "f" = "#E0796F")) +
  scale_y_discrete(limits = rev(levels(factor(sw.wrangled.plot3$species_firstchar))))

# Assignment 13
# Plot - Mass and weight across gender presentation
library(tidyverse)

sw.facet_data <- sw.wrangled %>%
  mutate(gender = ifelse(is.na(gender), "Other", gender)) %>%
  filter(!is.na(mass)) %>%
  mutate(`gender` = replace(`gender`, `gender` == "m", "Male")) %>%
  mutate(`gender` = replace(`gender`, `gender` == "f", "Female")) %>%
  mutate(`gender` = replace(`gender`, `gender` == "other", "Other")) %>%
  select(`height_cm`, `mass`, `gender`)

gender_colors <- c("Female" = "#75150C", "Male" = "#767575", "Other" = "#F1A841")

sw.facet_data %>%
  ggplot(aes(x = height_cm, y = mass, color = gender, se=TRUE)) +
  geom_point() +
  geom_smooth(method = "lm", se = TRUE, fill = "#CCCCFC") + 
  facet_wrap( ~ gender, scales = "free_y") +
  labs(title = "Height and weight across gender presentation",
       subtitle = "A cautionary tale in misleading \"free\" axis scales & bad design choices",
       x = "Height (cm)",
       y = "Mass (kg)",
       color = "Gender Presentation") +
  scale_x_continuous(breaks = seq(60, 270, by = 30)) +
  scale_color_manual(values = gender_colors) + 
  theme(
    plot.title = element_text(family = "Comic Sans MS", size = 12),
    plot.subtitle = element_text(family = "Comic Sans MS"),
    axis.title = element_text(family = "Comic Sans MS", size = 10),
    legend.position = "bottom",
    legend.background = element_rect(fill = "#C5C6FD"),
    legend.text = element_text(family = "Comic Sans MS", size = 8),
    legend.title = element_text(family = "Brush Script MT", size = 14),
    strip.background = element_rect(fill = "#2C580D"),
    strip.text = element_text(family = "Courier New", size = 10, color = "white", hjust = 0),
    panel.background = element_rect(fill = "#FAECEC"),
    panel.border = element_rect(color = "black", fill = NA),
    panel.grid.major.y = element_line(linetype = "dotdash", color = "#CDCDCD"),
    panel.grid.minor.y = element_blank(),
    panel.grid.major.x = element_line(linetype = "dashed"),
    panel.grid.minor.x = element_blank(),
    legend.key = element_rect(fill = 'white'),
    axis.text.x = element_text(angle = 45, hjust = 1, family = "Comic Sans MS", size = 8),
    axis.text.y = element_text(face = "italic", family = "Comic Sans MS", size = 8)
  )
