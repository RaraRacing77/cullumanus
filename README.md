# Cullumanus Project

This project analyses species distributions in Spain for Lepidoptera, Hymenoptera, and Odonata using GBIF data.  
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

