# Load required libraries
library(shiny)
library(leaflet)
library(leaflet.extras)
library(sf)
library(terra)

source("CountryMapModule.R")
source("BIomeMapModule.R")
source("EcorregionMapModule.R")
source("DrawMapModule.R")
source("MapModule.R")

# Read the world map shapefile
world_sf <- terra::vect("data/world_map.shp")
biomes <- terra::vect("data/biomes.shp")
ecorregions <- terra::vect("data/Ecoregions2017.shp")

# Define the UI for the main app
ui <- MapModuleUI("map_module")

# Define the server for the main app
server <- function(input, output, session) {
  MapModuleServer("map_module", world_sf, biomes, ecorregions)
}

# Run the Shiny app
shinyApp(ui, server)
