library(tidyverse)
library(raster)

directory <- "/Volumes/Javier_nuevo/Biologia/Analisis/_Rprojects/GCM_compareR_AWS_CMIP6/clim_data/worldclimCMIP6/"

temp <- tempfile()
res <- "10m"

# Download present

pre_dir <- "https://biogeo.ucdavis.edu/data/worldclim/v2.1/base/"

## Download the data
download.file(paste0(pre_dir, "wc2.1_", res, "_bio", ".zip"),
              temp)
rdata <- unzip(temp) %>% stack

## Save
dir.create(paste0(directory, names(rdata)[1] %>% gsub("_bio_1$", "", .)), showWarnings = F)
writeRaster(rdata, 
            paste0(directory, names(rdata)[1] %>% gsub("_bio_1$", "", .), "/", 
                   names(rdata) %>% gsub("bio_", "bio", .), ".tif"),
            bylayer = T,
            overwrite = T)


# Download future

fut_dir <- "http://biogeo.ucdavis.edu/data/worldclim/v2.1/fut/10m/"
# res <- "10m"
gcms <- c("BCC-CSM2-MR", "CNRM-CM6-1", "CNRM-ESM2-1", "CanESM5", "GFDL-ESM4", 
          "IPSL-CM6A-LR", "MIROC-ES2L", "MIROC6", "MRI-ESM2-0")

ssps <- c("ssp126", "ssp245", "ssp370", "ssp585")

periods <- c("2021-2040", "2041-2060", "2061-2080", "2081-2100")


## Function to download and save future layers
downloadFuture <- function(gcm, ssp, per, directory){
  glue::glue("Downloading {gcm} for {ssp} and the period {period}") %>% print
  
  # Download the file and unzip
  # temp <- tempfile()
  download.file(paste0(fut_dir, "wc2.1_", res, "_bioc_", gcm, "_", ssp, "_", period, ".zip"),
                temp)
  rdata <- unzip(temp) %>% stack
  
  # Save
  dir.create(paste0(directory, names(rdata)[1] %>% gsub("\\.1$", "", .)), showWarnings = F)
  writeRaster(rdata, 
              paste0(directory, names(rdata)[1] %>% gsub("\\.1$", "", .), "/", 
                     names(rdata), ".", paste0("bio", 1:19), ".tif"),
              bylayer = T,
              overwrite = T)
}

## Loop through options and download
for (gcm in gcms){
  for (ssp in ssps){
    for (period in periods){
      # Check if it's done
      down_files <- list.files(paste0(directory, "wc2.1_", res, "_bioc_", 
                                      gcm %>% gsub("-", "\\.", .), "_", ssp, "_", 
                                      period %>% gsub("-", "\\.", .)))
      
      # If it isn't download it 
      if(length(down_files) < 19){
        try(downloadFuture(gcm, ssp, per, directory))
      }
    }
  }
}


# There are two combinations that are not available (although they are shown as available):
# wc2.1_10m_bioc_IPSL.CM6A.LR_ssp245_2021.2040    &    wc2.1_10m_bioc_MRI-ESM2-0_ssp585_2021-2040
