library(terra)
library(dplyr)
library(tidyr)
library(magrittr)

world_sf <- terra::vect("data/world_map.shp") 



TestFiles <- list.files(path = "clim_data/worldclimCMIP6", pattern = ".tif", recursive = T, full.names = T)

TestFiles <- TestFiles[stringr::str_detect(TestFiles, "2081.2100")] 

TestFiles <- TestFiles[stringr::str_detect(TestFiles, "ssp370")] 

NoPath <- sub(".*/", "", TestFiles)

Names <- NoPath |> 
  stringr::str_remove_all("wc2.1_10m_bioc_") |>
  stringr::str_remove_all("_ssp370") |> 
  stringr::str_remove_all("2081.2100.1.") |> 
  stringr::str_remove_all(".tif")

DF <- data.frame(Names = Names, path = TestFiles) |> 
  tidyr::separate(col = Names, into = c("GCM", "Biovar"), sep = "_") |> 
  dplyr::mutate(n_var = readr::parse_number(Biovar)) |> 
  dplyr::arrange(GCM, n_var) |> 
  dplyr::group_split(GCM)

denmark <- world_sf[world_sf$country == "Denmark",]

TestResult <-DF[[1]]$path |> 
  terra::rast() |> 
  terra::crop(denmark) |> 
  terra::mask(denmark) |> 
  magrittr::set_names(DF[[1]]$Biovar)

TestResult <-DF |> purrr::map(~dplyr::pull(.x, path)) |> 
  purrr::map(terra::rast) |> 
  purrr::map(~terra::crop(.x, denmark)) |> 
  purrr::map(~terra::mask(.x, denmark)) |> 
  purrr::map(~magrittr::set_names(.x, DF[[1]]$Biovar))

stack <- purrr::reduce(TestResult, c)

ensemble <- tapp(stack, names(stack), mean)
SD <- tapp(stack, names(stack), sd)

ScaledResult <- TestResult |> purrr::map(~((.x - ensemble)/SD))

ScaledResult |> purrr::map(~global(.x, "mean", na.rm = T))

TestResult |> purrr::map(~global(.x, "mean", na.rm = T))


rast_noise <- function(raster, noise_mean = 0, noise_sd = 1) {
  # Generate random noise with the same dimensions as the raster
  random_noise <- rnorm(n = ncell(raster), mean = noise_mean, sd = noise_sd)
  
  # Reshape the random noise to match the raster's dimensions
  random_noise <- rast(matrix(random_noise, nrow = nrow(raster), ncol = ncol(raster)))
  
  # Add random noise to the raster
  noisy_raster <- raster + random_noise
  
  return(noisy_raster)
}

