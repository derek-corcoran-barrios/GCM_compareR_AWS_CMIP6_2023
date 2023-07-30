# Rename files
library(terra)

folders <- list.files("clim_data/temp/worldclimCMIP6")
folders <- folders[3:length(folders)]


for (folder in folders){
  # folder <- folders[1]
  folder_name <- folder %>% str_replace_all("-", "\\.")
  
  dir.create(paste0("clim_data/worldclimCMIP6_2023/", folder_name), showWarnings = F)
  
  files <- list.files(paste0("clim_data/temp/worldclimCMIP6/", folder), pattern = ".tif")
  
  for (file in files){
    # file <- files[1]
    file_name <- file %>% str_replace_all("-", "\\.") %>% 
      str_replace_all("_bio01.tif", ".1.bio1.tif") %>% 
      str_replace_all("_bio02.tif", ".1.bio2.tif") %>% 
      str_replace_all("_bio03.tif", ".1.bio3.tif") %>% 
      str_replace_all("_bio04.tif", ".1.bio4.tif") %>% 
      str_replace_all("_bio05.tif", ".1.bio5.tif") %>% 
      str_replace_all("_bio06.tif", ".1.bio6.tif") %>% 
      str_replace_all("_bio07.tif", ".1.bio7.tif") %>% 
      str_replace_all("_bio08.tif", ".1.bio8.tif") %>% 
      str_replace_all("_bio09.tif", ".1.bio9.tif") %>% 
      str_replace_all("_bio10.tif", ".1.bio10.tif") %>% 
      str_replace_all("_bio11.tif", ".1.bio11.tif") %>% 
      str_replace_all("_bio12.tif", ".1.bio12.tif") %>% 
      str_replace_all("_bio13.tif", ".1.bio13.tif") %>% 
      str_replace_all("_bio14.tif", ".1.bio14.tif") %>% 
      str_replace_all("_bio15.tif", ".1.bio15.tif") %>% 
      str_replace_all("_bio16.tif", ".1.bio16.tif") %>% 
      str_replace_all("_bio17.tif", ".1.bio17.tif") %>% 
      str_replace_all("_bio18.tif", ".1.bio18.tif") %>% 
      str_replace_all("_bio19.tif", ".1.bio19.tif")
    
    r <- rast(paste0("clim_data/temp/worldclimCMIP6/", folder, "/", file))
    
    writeRaster(r, 
                paste0("clim_data/worldclimCMIP6_2023/", folder_name, "/", file_name),
                overwrite = T, gdal = c("COMPRESS=DEFLATE", "TFW=YES", "of=COG"))
    
  }
  
}



folders <- list.files("clim_data/worldclimCMIP6")

for (folder in folders){
  # folder <- folders[1]
  # folder_name <- folder %>% str_replace_all("-", "\\.")
  
  dir.create(paste0("clim_data/worldclimCMIP6_new/", folder), showWarnings = F)
  
  files <- list.files(paste0("clim_data/worldclimCMIP6/", folder), pattern = ".tif")
  
  for (file in files){
    # file <- files[1]
    # file_name <- file %>% str_replace_all("-", "\\.") %>% 
    #   str_replace_all("_bio01.tif", ".1.bio1.tif") %>% 
    #   str_replace_all("_bio02.tif", ".1.bio2.tif") %>% 
    #   str_replace_all("_bio03.tif", ".1.bio3.tif") %>% 
    #   str_replace_all("_bio04.tif", ".1.bio4.tif") %>% 
    #   str_replace_all("_bio05.tif", ".1.bio5.tif") %>% 
    #   str_replace_all("_bio06.tif", ".1.bio6.tif") %>% 
    #   str_replace_all("_bio07.tif", ".1.bio7.tif") %>% 
    #   str_replace_all("_bio08.tif", ".1.bio8.tif") %>% 
    #   str_replace_all("_bio09.tif", ".1.bio9.tif") %>% 
    #   str_replace_all("_bio10.tif", ".1.bio10.tif") %>% 
    #   str_replace_all("_bio11.tif", ".1.bio11.tif") %>% 
    #   str_replace_all("_bio12.tif", ".1.bio12.tif") %>% 
    #   str_replace_all("_bio13.tif", ".1.bio13.tif") %>% 
    #   str_replace_all("_bio14.tif", ".1.bio14.tif") %>% 
    #   str_replace_all("_bio15.tif", ".1.bio15.tif") %>% 
    #   str_replace_all("_bio16.tif", ".1.bio16.tif") %>% 
    #   str_replace_all("_bio17.tif", ".1.bio17.tif") %>% 
    #   str_replace_all("_bio18.tif", ".1.bio18.tif") %>% 
    #   str_replace_all("_bio19.tif", ".1.bio19.tif")
    
    
    r <- rast(paste0("clim_data/worldclimCMIP6/", folder, "/", file))
    names(r) <- file %>% str_replace_all(".tif", "")
    
    writeRaster(r, 
                paste0("clim_data/worldclimCMIP6_new/", folder, "/", file),
                overwrite = T, gdal = c("COMPRESS=DEFLATE", "TFW=YES", "of=COG"))
    
  }
  
}







