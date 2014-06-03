### Loading the necessary datasets ###

relief_web <- read.csv('data/ReliefWeb_all_data.csv')

# Cleaning the fields.
relief_web$created <- as.Date(relief_web$created)

