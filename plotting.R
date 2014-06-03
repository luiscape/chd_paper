### Plotting snippets ###

library(ggplot2)
library(hdxdictionary)

# Timeline with all events in the database.
gen_timeline <- ggplot(relief_web) + theme_bw() +
    geom_line(aes(created), stat = 'bin', size = 1.3, color = "#0988bb")

## Timeline with the events per country. ##
# Subset 1: have more than 1000 reports over the period (~.002).
# Subset 2: has .01 of the database (~5510 reports).

# Creating subset limits.
lim1 <- nrow(relief_web) * .002
lim2 <- nrow(relief_web) * .01

# Cleaning.
report_count <- data.frame(table(relief_web$iso3))
names(report_count) <- c('iso3', 'count')

# Creating the subsetting lists.
sub1 <- subset(report_count, (count > lim1 & iso3 != 'wld'))  # 81 countries.
sub2 <- subset(report_count, (count > lim2 & iso3 != 'wld'))  # 30 countries.

## Timeline min ##
timeline_country_min <- subset(relief_web, (iso3 == as.character(sub1$iso3)))
timeline_country_min$country_name <- hdxdictionary(toupper(timeline_country_min$iso3),
                                                   'iso3c', 'country.name')

plotMinTimeline <- ggplot(timeline_country_min) + theme_bw() +
    geom_area(aes(created), stat = 'bin', alpha = .1, fill = "#0988bb") + 
    geom_line(aes(created), stat = 'bin', size = 1.3, color = "#0988bb") + 
    facet_wrap(~ iso3)
    # add theming + theme() to get rid of 
    # grids and etc.


## Timeline max ##
timeline_country_max <- subset(relief_web, (iso3 == as.character(sub2$iso3)))
timeline_country_max$country_name <- hdxdictionary(toupper(timeline_country_max$iso3), 
                                                   'iso3c', 'country.name')
timeline_country_max$iso3 <- toupper(timeline_country_max$iso3)

plotMaxTimeline <- ggplot(timeline_country_max) + theme_bw() +
    geom_area(aes(created), stat = 'bin', alpha = .1, fill = "#0988bb") + 
    geom_line(aes(created), stat = 'bin', size = 1.3, color = "#0988bb") + 
    facet_wrap(~ iso3)


## Bar plot with the distribution of the max 30 countries. 
# improve font
# order the bars
maxBar <- data.frame(table(as.character(timeline_country_max$iso3)))
names(maxBar) <- c('iso3', 'quantity')
plotMaxBar <- ggplot(maxBar) + theme_bw() + 
    geom_bar(aes(iso3, quantity), stat = "identity") +
    coord_flip() + 
    geom_text(aes(iso3, quantity, label = quantity),  
              position = position_dodge(width=0.9), hjust=-0.25) + 
    theme(axis.text.x = element_text(angle = 90, hjust = 1))
