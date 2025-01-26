library(tidycensus)
library(tidyverse)
library(leaflet)
library(sf)
library(viridis)


# Define the variables you want to extract
education_variables <- c(
  "B15003_022",  # Bachelor's degree
  "B15003_023",  # Master's degree
  "B15003_024",  # Professional school degree
  "B15003_025",  # Doctorate degree
  "B01003_001"   # Total population (for percentage calculations)
)

# Fetch the data
fl_education_data <- get_acs(
  geography = "tract",  # Use "block group" for block group level
  variables = education_variables,  # Include all variables
  state = "FL",  # Florida
  year = 2023,  # Specify the year
  survey = "acs5",  # 5-year ACS data
  geometry = TRUE  # Set to TRUE if you want spatial data
)

# Reshape the data to wide format for easier calculationsdata:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB4AAAAeCAYAAAA7MK6iAAACBUlEQVR4Xu1Wy07CQBR164e4U+xK/AbXJgKJNm70C/wD3fkL9iuUKNHExJWJugEER6A8CvIoIPKw1cV1ziQltRg6oAsXPclZMfeee2cuPXdh4T9BUcJLIWVNXQ6tHYZWw8fzUMTyHMjlzf8jVpTwRiSyc5JIXDHGcnaxWCI/6npRsFDQKZ8v0PNzjtLpjH0Wv2Cbke0T5PTqfAOqi8V2NR5sGUaVDKMmySpVKgaVyxVRCArI5fLEC6dkMm1tRVVtaue4muvrG1avN6nRaFGzaUoRZxFTq9VFISgAN+CIn56dM+T26o2Bd6lWX+x2u0udzit1uz0p4ixiWq22KIDnEOLoHNeeSj1+LCvrR169MTAUSNTr9entbUD9/pAWDy7mIjovlcrizdE1cnv1xsCPEBwMRjQcvtNoZE0klCWu3d21rzBEIWhZH4LehLLElWPg8NZSwugUgrb9KehNKEsMHKbdGTJfYafb3wpj2vHO+HsFwhMIhAPhWRgITxWGLXJ3st3CskQMPrcwGdik+5OZyWR9bJGb9d3dA3ObhCwRA4OBpcKb3SYRjyemLwJYT9Tdfc00u5ZjizLEWYiiW/g5FgLHFrPZJyvK16mpqw+AxWxH3dNub+8ZvzIby4AfIYhOIWqaHdGtrpfsy8srFo2pmu+y52C83vJ3wVDMQxE7y3obIMBf4QuyPyGTYZDxcQAAAABJRU5ErkJggg==
fl_education_wide <- fl_education_data %>%
  select(GEOID, NAME, variable, estimate) %>%
  tidyr::pivot_wider(names_from = variable, values_from = estimate)

# Calculate percentages for each education level
fl_education_wide <- fl_education_wide %>%
  mutate(
    pct_bachelors = (B15003_022 / B01003_001) * 100,
    pct_masters = (B15003_023 / B01003_001) * 100,
    pct_professional = (B15003_024 / B01003_001) * 100,
    pct_doctorate = (B15003_025 / B01003_001) * 100
  )

# View the resulting data
head(fl_education_wide)


write_rds(fl_education_wide, file= "fl_data.rds" )
