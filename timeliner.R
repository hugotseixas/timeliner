## ------------------------------------------------------------------------- ##
####* ------------------------------- HEADER ---------------------------- *####
## ------------------------------------------------------------------------- ##
##
#### Description ####
##
## Script name:   Create a research time line
##
## Description:   This is a simple routine that reads a .csv file with research
##                tasks and their start and end dates, and plots a beautiful
##                research time line. Each individual task should have a unique
##                id, and you can group your tasks into sections, which will
##                be plotted in different colors, using a colorblind safe
##                palette. The palette is composed of 9 colors, if you exceed
##                this number of sections, consider reducing it or increasing
##                the number of colors of the palette. If you don't want 
##                colors, you can set all section values to NA.
##
## Author:        Hugo Tameirão Seixas
## Contact:       hugo.seixas@alumni.usp.br / tameirao.hugo@gmail.com
##
## Date created:  2020-09-02
## Last update:   2020-10-10
## Last tested:   2020-10-10
##
## Copyright (c) Hugo Tameirão Seixas, 2020
##
## ------------------------------------------------------------------------- ##
##
## Notes:         The color palette was copied from Paul Tol"s notes: 
##                https://personal.sron.nl/~pault/
##                https://personal.sron.nl/~pault/data/colourschemes.pdf
##
## ------------------------------------------------------------------------- ##
##
#### Libraries ####
##
library(magrittr)
library(lubridate)
library(glue)
library(tidyverse)
##
## ------------------------------------------------------------------------- ##
##
#### Options ####
##
colors <- c( # Color palette
  "#332288", "#88CCEE", "#44AA99", 
  "#117733", "#999933", "#DDCC77", 
  "#CC6677", "#882255", "#AA4499"
  ) 

plot_options <- list( 
  plot_width = 15, # Plot width in cm
  plot_height = 12, # Plot height in cm
  plot_format = 'pdf' # The output format of your time line
  )
##
## ------------------------------------------------------------------------- ##
####* ------------------------------- CODE ------------------------------ *####
## ------------------------------------------------------------------------- ##

####' ----- Load time line information #### 
timeline_table <- read_csv(
  file = "timeline.csv", 
  col_types = cols(activity = col_factor())
  )

####' ----- Mutate variables #### 
timeline_table %<>%
  mutate(
    activity = reorder(activity, desc(activity)),
    start = dmy(start),
    end = dmy(end),
    section = factor(section)
    )

####' ----- Convert tibble to long format #### 
timeline_table %<>%
  gather(
    key = "when", 
    value = "date", 
    start, 
    end
    )

####' ----- Plot time line #### 
(timeline_plot <- timeline_table %>%
  ggplot() +
  geom_line(
    aes(x = date, y = activity, group = id, color = section), 
    size = 3, 
    lineend = "round"
    ) +
  scale_x_date(date_labels = "%Y") +
  scale_colour_manual(
    values = colors, 
    na.value = "#DDDDDD", 
    breaks = levels(timeline_table$section)
    ) +
  labs(color = "Section") +
  theme_minimal() + 
  theme(
    text = element_text(family = "sans", size = 12), 
    axis.title = element_blank(),
    axis.text.x = element_text(angle = 40, vjust = 0.6),
    plot.margin = margin(0.5, 0.5, 0.5, 0.5, "cm"),
    legend.position = "bottom"
    ))

####' ----- Save time line #### 
timeline_plot %>%
  ggsave(
    filename = glue("timeline.{plot_options$plot_format}"), 
    width = plot_options$plot_width, 
    height = plot_options$plot_height, 
    units = "cm"
    )

try(praise::praise("${EXCLAMATION}! Your time line is so ${adjective}!"))

## ------------------------------------------------------------------------- ##
####* ------------------------------- END ------------------------------- *####
## ------------------------------------------------------------------------- ##