library(readr)
library(dplyr)
library(ggplot2)
library(stringr)

# Load the cleaned GBIF data set ... use the clean_species.R script first! That creates the CSV you load in below.
gbif_df <- read_csv("data/processed/hymenoptera/bombus_inexspectatus/bombus_inexspectatus_spain_clean.csv")
gbif_df <- gbif_df %>%
  mutate(individualCount = ifelse(is.na(individualCount), 1, individualCount)
)
head(gbif_df)

# Load the cleaned Atlas data set ... use the clean_atlas.R script first! That creates the CSV you load in below.
atlas_df <- read_csv("data/processed/hymenoptera/bombus_inexspectatus/bombus_inexspectatus_atlas_clean.csv")

# Some additional cleaning to get it ready for visualization.
# We need to remove invalid years like "0" and "0000" to make them NA (as in GBIF data).
atlas_clean <- atlas_df %>%
  mutate(
    year = suppressWarnings(as.numeric(year)), # Convert to the column to numeric
    year = ifelse(year %in% c(0, 0000), NA, year)) %>%
# Then, filter to Spain only because the file does not have country codes.
  filter(
    decimalLatitude >= 36 & decimalLatitude <= 44,
    decimalLongitude >= -9.5 & decimalLongitude <= 4.5
  )

# Now to merge both data sets.
combined <- bind_rows(gbif_df, atlas_clean)

# Save unified file to use in Tableau for vislualization.
write_csv(combined, "data/processed/hymenoptera/bombus_inexspectatus/bombus_inexspectatus_combined.csv")

# However, some contentious occurrences were found!
# source("R/gazetteer_locations.R")
# gazetteer <- readr::read_csv("data/reference/gazetteer.csv")
combined_checked <- check_locations(combined) # This is a function created with the gazetteer_locations.R script.

# Manually adding a note for a location labeled "Asturias".
combined_checked$contentious[54] <- "Location mismatch >10km"
combined_checked$notes[54] <- "Manual entry for validation"

# Returning a table of contentious observations.
contentious_table <- combined_checked %>%
  filter(contentious != "OK" & !is.na(contentious)) %>%
  select(
    gbifID,
    year,
    locality,
    decimalLatitude,
    decimalLongitude,
    distance_to_ref,
    contentious,
    associatedReferences
  ) %>%
  arrange(locality, year)

contentious_table <- contentious_table %>%
  mutate(flagged_on = Sys.Date())

# Saving both outputs to the data/processed/... folder.
write_csv(contentious_table, "data/processed/hymenoptera/bombus_inexspectatus/contentious_records.csv")
write_csv(combined_checked, "data/processed/hymenoptera/bombus_inexspectatus/bombus_inexspectatus_combined_clean.csv")