## ------------------------------------------------------------------------- ##
####* ------------------------------- HEADER ---------------------------- *####
## ------------------------------------------------------------------------- ##
##
#### Description ####
##
## Script name:   
##
## Description:    
##                 
##                
##                 
##                
##                 
##                
##                
##
## Author:        Hugo Tameirao Seixas
## Contact:       hugo.seixas@alumni.usp.br / tameirao.hugo@gmail.com
##
## Date created:  
## Last update:   
## Last tested:   
##
## Copyright (c) Hugo Tameirao Seixas, 2020
##
## ------------------------------------------------------------------------- ##
##
## Notes:           
##                  
##                               
##
## ------------------------------------------------------------------------- ##
##
#### Libraries ####
##
library(magrittr)
library(lubridate)
library(tidyverse)
##
## ------------------------------------------------------------------------- ##
##
#### Options ####
##
options(scipen = 6, digits = 4) # View outputs in non-scientific notation
##
## ------------------------------------------------------------------------- ##
####* ------------------------------- CODE ------------------------------ *####
## ------------------------------------------------------------------------- ##

####' ----- Load schedule information #### 
timeline <- read_csv(
  file = 'timeline.csv', 
  col_types = cols(activity = col_factor())
  )

####' ----- Mutate variables #### 
timeline %<>%
  mutate(
    activity = reorder(activity, desc(activity)),
    start = dmy(start),
    end = dmy(end),
    section = factor(section)
    )

####' ----- Convert tibble to long format #### 
timeline %<>%
  gather(
    key = 'when', 
    value = 'date', 
    start, 
    end
    )

####' ----- Set palette #### 
colors <- c('#577590', '#BCAA99', '#ED9B40', '#BA3B46')

####' ----- Plot schedule #### 
ggplot(data = timeline) +
  geom_line(
    aes(x = date, y = activity, group = id, color = section), 
    size = 3, 
    lineend = 'round'
    ) +
  scale_x_date(date_labels = '%Y') +
  scale_colour_manual(
    values = colors, 
    na.value = 'gray40', 
    breaks = levels(timeline$section)
    ) +
  labs(color = 'Section') +
  theme_minimal() + 
  theme(
    text = element_text(family = "sans", size = 12), 
    axis.title = element_blank(),
    axis.text.x = element_text(angle = 40, vjust = 0.6),
    plot.margin = margin(0.5, 0.5, 0.5, 0.5, "cm"),
    legend.position = 'bottom'
    ) +
  ggsave(
    filename = 'schedule.pdf', 
    width = 15, 
    height = 12, 
    units = 'cm'
    )

## ------------------------------------------------------------------------- ##
####* ------------------------------- END ------------------------------- *####
## ------------------------------------------------------------------------- ##