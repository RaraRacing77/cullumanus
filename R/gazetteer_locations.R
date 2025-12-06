library(tibble)
library(dplyr)
library(geosphere)
library(stringi)

gazetteer <- read_csv("data/reference/gazetteer.csv")

# This was my initial table ... DO NOT USE AGAIN!
# gazetteer <- tibble(
#  locality = c("Puerto de Ranadoiro", "Puerto de Tarna", "Puerto de San Glorio", "Puerto de las Senales", "Marana", "Puerto de Pajares", "Puerto de la Magdalena", "Puerto de Leitariegos", "Puerto el Palo", "Fuente De", "Puerto de Aralla"),
#  ref_lat  = c(42.996811, 43.084289, 43.066884, 43.075495, 43.049310, 42.992931, 42.867892, 42.998381, 43.272423, 43.144041, 42.903926),
#  ref_lon  = c(-6.634890, -5.217645, -4.765728, -5.243387, -5.180763, -5.759654, -6.210745, -6.417662, -6.677801, -4.811635, -5.804721),
#  notes    = c("Google Maps_manual", "Google Maps_manual", "Google Maps_manual", "Google Maps_manual", "Google Maps_manual", "Google Maps_manual", "Google Maps_manual", "Google Maps_manual", "Google Maps_manual", "Google Maps_manual", "Google Maps_manual")
#)

# Normalize locality names by removing accents for better matching for gazatteer function.
combined <- combined %>%
  mutate(locality_norm = stri_trans_general(locality, "Latin-ASCII")) # This combined df comes from the clean_species.R and clean_atlas.R scripts.
gazetteer <- gazetteer %>%
  mutate(locality_norm = stri_trans_general(locality, "Latin-ASCII")) # Just to be sure.

# Function to check locations against gazetteer.
check_locations <- function(df) {
  df %>%
    left_join(gazetteer, by = "locality") %>%
    mutate(
      distance_to_ref = ifelse(
        !is.na(ref_lat) & !is.na(ref_lon),
        round(
          geosphere::distHaversine(
            cbind(decimalLongitude, decimalLatitude),
            cbind(ref_lon, ref_lat)
          ) / 1000,  # convert to km
          1           # round to 1 decimal place
        ),
        NA
      ),
      contentious = case_when(
        !is.na(distance_to_ref) & distance_to_ref > 10 ~ "Location mismatch >10km",
        TRUE ~ "OK"
      )
    )
}

# Example usage:
combined_checked <- check_locations(combined)
