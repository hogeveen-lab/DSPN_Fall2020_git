# R Standard

# This would just be for writing code
# Lighter weight, sometimes easier to work with when you're just getting familiar

# libraries
library(tidyverse)

# paths
base_dir <- '/Users/jeremyhogeveen/Dropbox/Fall_2020/teaching/DSPN_Fall2020_git/misc_exercises/imitation_inhibition_paradigm'
data_dir <- paste(base_dir,'data/second',sep='/')

# filename
sublevel_file <- paste(data_dir,'ait_subjectlevel.csv',sep='/')

# Read in the data and check it
df <- read_csv(sublevel_file)

# reshaping the data frame to long
df_long <- df %>%
  pivot_longer(cols = baseline:movement_incongruent,
               names_to = 'condition',
               values_to = 'rt')
# plotting the data as a boxplot data separated by condition
plot(box_by_condition <- ggplot(df_long,aes(x = condition, y=rt)) +
       geom_boxplot() +
       theme(axis.text.x = element_text(angle = 45, vjust=0.5)))