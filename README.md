# Cullumanus Project

This project analyzes species distributions in Spain for Lepidoptera, Hymenoptera, and Odonata using GBIF data.  
There is a focus on Cantabrian species and their conservation status.  
The results will be published on the blog *Searching for Cullumanus*.

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

## Data Structure and Versioning
This project follows a modular data structure to support reproducibility, governance, and collaborative workflows:
- data/raw/ — Contains original, unprocessed data files.

This folder is excluded from version control via .gitignore to avoid bloating the repository and to protect sensitive or large files.
All cleaning scripts operate on these files locally.

- data/reference/ — Stores curated reference files such as gazetteer.csv, which provides trusted coordinates for locality validation.
- data/processed/... — Contains cleaned and flagged datasets, including:
	- combined_clean.csv — Full cleaned dataset with location diagnostics.
 	- contentious_records.csv — Subset of records flagged for location mismatch (>10 km).
---
