# make copy of CMIP5 tifs consistent with CMIP6 naming

# Future
files <- list.files("D:/Biologia/Analysis/_Rprojects/GCM_compareR_AWS_CMIP6/clim_data/ccafs/raw_rasters",
           full.names = F,
           pattern = ".tif")

for (f in 1:length(files)){
  file <- files[f]
  raster <- raster(paste0("D:/Biologia/Analysis/_Rprojects/GCM_compareR_AWS_CMIP6/clim_data/ccafs/raw_rasters/", file))
  
  gcm <- file %>% str_split(pattern = "\\.") %>% .[[1]] %>% .[1] %>% toupper() %>% 
    str_replace_all("_", "\\.")
  res <- file %>% str_split(pattern = "\\.") %>% .[[1]] %>% .[2]
  year <- file %>% str_split(pattern = "\\.") %>% .[[1]] %>% .[3] %>% 
    str_replace("year", "")
  sce <- file %>% str_split(pattern = "\\.") %>% .[[1]] %>% .[4]
  bio <- file %>% str_split(pattern = "\\.") %>% .[[1]] %>% .[5] %>% 
    str_replace("_", "")
  
  layer_name <- paste0("wc1.4_",
                       res,
                       "_bioc_",
                       gcm, "_",
                       sce, "_",
                       year, ".1.",
                       bio)
  glue::glue("File {layer_name}") %>% print
  names(raster) <- layer_name
    
  folder_name <- paste0("wc1.4_",
                        res,
                        "_bioc_",
                        gcm, "_",
                        sce, "_",
                        year)
  dir.create(paste0("D:/Biologia/Analysis/_Rprojects/GCM_compareR_AWS_CMIP6/clim_data/worldclimCMIP5/", 
                    folder_name), showWarnings = F)
  
  writeRaster(raster, paste0("D:/Biologia/Analysis/_Rprojects/GCM_compareR_AWS_CMIP6/clim_data/worldclimCMIP5/",
                             folder_name, "/",
                             layer_name, ".tif"), 
              overwrite = T)
}


# Present
files <- list.files("D:/Biologia/Analysis/_Rprojects/GCM_compareR_AWS_CMIP6/clim_data/baseline/raw_rasters",
                    full.names = F,
                    pattern = ".tif")

for (f in 1:length(files)){
  file <- files[f]
  raster <- raster(paste0("D:/Biologia/Analysis/_Rprojects/GCM_compareR_AWS_CMIP6/clim_data/baseline/raw_rasters/", file))
  
  res <- file %>% str_split(pattern = "\\.") %>% .[[1]] %>% .[2]
  bio <- file %>% str_split(pattern = "\\.") %>% .[[1]] %>% .[3] %>% 
    str_replace("_", "")
  
  layer_name <- paste0("wc1.4_",
                       res, "_",
                       bio)
  glue::glue("File {layer_name}") %>% print
  names(raster) <- layer_name
  
  folder_name <- paste0("wc1.4_", res)
  dir.create(paste0("D:/Biologia/Analysis/_Rprojects/GCM_compareR_AWS_CMIP6/clim_data/worldclimCMIP5/", 
                    folder_name), showWarnings = F)
  
  writeRaster(raster, paste0("D:/Biologia/Analysis/_Rprojects/GCM_compareR_AWS_CMIP6/clim_data/worldclimCMIP5/",
                             folder_name, "/",
                             layer_name, ".tif"), 
              overwrite = T)
}

# raster("D:/Biologia/Analysis/_Rprojects/GCM_compareR_AWS_CMIP6/clim_data/worldclimCMIP6/wc2.1_10m/wc2.1_10m_bio1.tif")
