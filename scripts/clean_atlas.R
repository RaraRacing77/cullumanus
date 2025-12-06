library(dplyr)
library(readr)
library(lubridate)

clean_atlas <- function(file_path, species_path, species_name,
                        log_file = "data/processed/summary_log.csv") {
  timestamp <- now(tzone = "Europe/Madrid")
  
  # Read Atlas file (skip metadata rows, tab-delimited)
  atlas <- read_delim(file_path, delim = "\t", skip = 2)
  
  # Harmonize into GBIF-style schema
  atlas_clean <- atlas %>%
    transmute(
      gbifID = NA,
      year = Year,
      locality = NA,
      decimalLatitude = Latitude,
      decimalLongitude = Longitude,
      individualCount = 1, # Set the count to 1 for each observation.
      sex = NA,
      associatedReferences = NA,
      identifiedBy = NA,
      basisOfRecord = "HUMAN_OBSERVATION",
      scientificName = species_name,
      source = "Atlas Hymenoptera"
    )
  
  # Save output
  out_dir <- dirname(file_path) %>% gsub("data/raw", "data/processed", .)
  dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
  out_file <- file.path(out_dir, paste0(basename(species_path), "_atlas_clean.csv"))
  write_csv(atlas_clean, out_file)
  
  # Update log
  log_entries <- tibble(
    species = basename(species_path),
    source = "Atlas Hymenoptera",
    records = nrow(atlas_clean),
    timestamp = timestamp
  )
  
  if (file.exists(log_file)) {
    existing_log <- read_csv(log_file, show_col_types = FALSE)
    updated_log <- bind_rows(existing_log, log_entries)
  } else {
    updated_log <- log_entries
  }
  write_csv(updated_log, log_file)
  
  message("✅ Atlas cleaning complete: ", out_file)
  
  return(atlas_clean)
}

# Example usage:
atlas_df <- clean_atlas(
  file_path = "data/raw/hymenoptera/bombus_inexspectatus/bombus_inexspectatus.csv",
  species_path = "hymenoptera/bombus_inexspectatus",
  species_name = "Bombus inexspectatus (Tkalcu, 1963)"
)

head(atlas_df)