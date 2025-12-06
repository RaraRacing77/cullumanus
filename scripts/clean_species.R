library(dplyr)
library(readr)
library(purrr)
library(lubridate)

# ---- PARAMETERS ----
# The GBIF "occurence.txt" has numerous columns, there are some columns to retain.
columns_to_keep <- c(
  "gbifID", "year", "locality", "decimalLatitude", "decimalLongitude", 
  "individualCount", "sex", "associatedReferences", "identifiedBy", 
  "basisOfRecord", "scientificName"
)

# Define species path to process below. REPLACE with your appropriate species!!!
species_path <- c(
  "hymenoptera/bombus_inexspectatus")

# ---- FUNCTION ----
clean_species <- function(species_path, extra_sources = NULL, log_file = "data/processed/summary_log.csv") {
  timestamp <- now(tzone = "Europe/Madrid")
  
  # Load GBIF raw data
  raw_file <- file.path("data/raw", species_path, "occurrence.txt")
  raw <- read_delim(raw_file, delim = "\t")
  
  # Clean GBIF data
  clean_gbif <- raw %>%
    filter(countryCode == "ES") %>%
    select(any_of(columns_to_keep)) %>%
    mutate(source = "GBIF")
  
  # Start combined dataset
  clean <- clean_gbif
  
  # Initialize log entries
  log_entries <- tibble(
    species = basename(species_path),
    source = "GBIF",
    records = nrow(clean_gbif),
    timestamp = timestamp
  )
  
  # Merge extra sources if provided
  if (!is.null(extra_sources)) {
    for (src in extra_sources) {
      src_file <- file.path("data/raw", species_path, src$file)
      if (file.exists(src_file)) {
        extra <- read_csv(src_file)
        
        # Harmonize column names if needed
        if (!is.null(src$rename)) {
          extra <- extra %>% rename(!!!src$rename)
        }
        
        # Add provenance
        extra <- extra %>%
          select(any_of(columns_to_keep)) %>%
          mutate(source = src$label)
        
        # Bind rows
        clean <- bind_rows(clean, extra)
        
        # Add to log
        log_entries <- bind_rows(log_entries, tibble(
          species = basename(species_path),
          source = src$label,
          records = nrow(extra),
          timestamp = timestamp
        ))
      }
    }
}
  
  # Save output
  out_dir <- file.path("data/processed", species_path)
  dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
  
  out_file <- file.path(out_dir, paste0(basename(species_path), "_spain_clean.csv"))
  write_csv(clean, out_file)
  
  # Update log
  if (file.exists(log_file)) {
    existing_log <- read_csv(log_file, show_col_types = FALSE)
    updated_log <- bind_rows(existing_log, log_entries)
  } else {
    updated_log <- log_entries
  }
  write_csv(updated_log, log_file)
  
  message("✅ Cleaning complete for ", species_path, ": ", out_file)
}

# Example call
clean_species("hymenoptera/bombus_inexspectatus")

# Run cleaner for each species
walk(species_path, ~ clean_species(.x,
                                   if (.x == "hymenoptera/bombus_inexspectatus") extra_sources_bombus else NULL
))