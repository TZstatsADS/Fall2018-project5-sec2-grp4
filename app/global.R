packages.used = c("shiny",
                  "shinydashboard",
                  "dplyr",
                  "leaflet",
                  "highcharter",
                  "shinyWidgets")

# check packages that need to be installed.
packages.needed = setdiff(packages.used,
                          intersect(installed.packages()[, 1],
                                    packages.used))
# install additional packages
if (length(packages.needed) > 0) {
  install.packages(packages.needed, dependencies = TRUE)
}

library(shiny)
library(shinydashboard)
library(leaflet)
library(dplyr)
library(highcharter)
library(shinyWidgets)

load("../output/PUMA_Demo.RData")
load("../output/restaurant_data.RData")
load("../output/EDA_Data.RData")
load("../output/demographic_info.RData")
