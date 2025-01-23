library(tidycensus)
library(tidyverse)
library(leaflet)
library(sf)
library(viridis)


fl_education_data <- get_acs(
  geography = "tract",  # You can also use "tract" or "block group" for more granularity
  variables = "B15003_022",  # Less than 9th grade education
  state = "FL",  # Florida
  year = 2021,  # Specify the year of the ACS data
  survey = "acs5",  # 5-year ACS estimates
  geometry = TRUE  # Set to TRUE if you want spatial data
)
write_rds(fl_education_data, file = "data.rds")
