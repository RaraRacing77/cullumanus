# setup_project_structure.R
# Run this once in a new RStudio project to scaffold folders

# Load required package
if (!require("fs")) install.packages("fs")
library(fs)

# Define taxonomic groups you want to track
taxa <- c("lepidoptera", "odonata", "hymenoptera")

# Create base folders
dir_create("data/raw")
dir_create("data/processed")
dir_create("scripts")
dir_create("R")
dir_create("outputs/maps")
dir_create("outputs/tables")
dir_create("docs")

# Create subfolders for each taxon
for (taxon in taxa) {
  dir_create(path("data/raw", taxon))
  dir_create(path("data/processed", taxon))
  dir_create(path("scripts", taxon))
}

# Add a README template
readme_text <- "# Cullumanus Project

This project analyzes species distributions in Spain for Lepidoptera, Hymenoptera, and Odonata using GBIF data.

## Folder Structure
- `data/raw/<taxon>/`: Raw GBIF downloads
- `data/processed/<taxon>/`: Cleaned CSVs for Tableau
- `scripts/<taxon>/`: R scripts for cleaning and analysis
- `R/`: Reusable helper functions
- `outputs/`: Maps and tables for blog/Tableau
- `docs/`: Quarto files and documentation
- `renv/` : Project environment files

## Workflow
1. Download species data from GBIF
2. Clean and process in R
3. Visualize in Tableau Public
4. Document workflow in Quarto
"

writeLines(readme_text, "README.md")

# Install minimal packages
install.packages(c(
  "here",
  "fs",
  "rgbif",
  "dplyr",
  "tidyr",
  "readr",
  "skimr",
  "janitor"
))

# Snapshot environment with renv
renv::snapshot()

############################################################
# Project: cullumanus
# Purpose: Initialize folder structure and install minimal 
#          package set for GBIF species distribution analysis
# Author: Bart van Hoof
# Date: 05.12.25
#
# Usage:
# 1. Run this script once inside the cullumanus RStudio project.
# 2. It will create the standard folder hierarchy.
# 3. It will install the minimal package set and snapshot them 
#    into renv for reproducibility.
#
# Notes:
# - Raw GBIF downloads go into data/raw/<taxon>/
# - Cleaned CSVs go into data/processed/<taxon>/
# - Scripts for each taxon live in scripts/<taxon>/
# - Outputs (maps, tables) are saved in outputs/
# - Documentation and Quarto files live in docs/
############################################################

# bootstrap_cullumanus.R
# Run this once inside your cullumanus project

# Minimal package set for GBIF workflows
packages <- c(
  "here",     # clean relative paths
  "fs",       # folder creation & file management
  "rgbif",    # GBIF data queries
  "dplyr",    # data manipulation
  "tidyr",    # reshaping & cleaning
  "readr",    # fast CSV import/export
  "skimr",    # quick dataset summaries
  "janitor"   # clean column names & tabulations
)

# Install any missing packages
for (pkg in packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg)
  }
}
#zynvox-kuMnu6-zuwjyg
#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
# Snapshot environment into renv.lock
renv::snapshot()

cat("✅ Minimal package set installed and snapshotted for cullumanus!\n")
