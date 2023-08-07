# Load required libraries
library(shiny)
library(leaflet)
library(leaflet.extras)
library(sf)
library(terra)

source("CountryMapModule.R")
source("BIomeMapModule.R")
source("EcorregionMapModule.R")
# Read the world map shapefile
world_sf <- terra::vect("data/world_map.shp")
biomes <- terra::vect("data/biomes.shp")
ecorregions <- terra::vect("data/Ecoregions2017.shp")
# Define the UI for the main app
ui <- fluidPage(
  titlePanel("Country Selection App"),
  CountryMapModuleUI("country_map_module"),
  BiomeMapModuleUI("biome_map_module"),
  EcorregionMapModuleUI("ecorregion_map_module"),
  radioButtons(
    inputId = "extent_type",
    label = NULL,
    choices = c(
      "Select drawing a rectangle over the map" = "map_draw",
      "Select by country/countries" = "map_country",
      "Select by biome(s)" = "map_biomes",
      "Select by ecorregion(s)" = "map_ecorregions",
      "Enter bounding-box coordinates" = "map_bbox"
    )),
  leafletOutput("map"),
  textOutput("Text")
)

# Define the server for the main app
server <- function(input, output, session) {
  rvs <- reactiveValues()
  rvs$polySelXY <- NULL
  rvs$saved_bbox <- NULL
  
  ex_type <- reactive(input$extent_type)
  
  # Create a leaflet map
  m <- leaflet(sf::st_as_sf(world_sf)) %>% 
    addTiles() %>%
    addProviderTiles("Esri.WorldPhysical", group = "Relieve") %>%
    addTiles(options = providerTileOptions(noWrap = TRUE), group = "Countries") %>%
    addLayersControl(baseGroups = c("Relieve", "Countries"),
                     options = layersControlOptions(collapsed = FALSE)) %>% 
    setView(0,0, zoom = 2) %>% 
    leaflet.extras::addDrawToolbar(targetGroup = 'draw', 
                                   singleFeature = TRUE,
                                   rectangleOptions = filterNULL(list(
                                     shapeOptions = drawShapeOptions(fillColor = "#8e113f",
                                                                     color = "#595959"))),
                                   polylineOptions = FALSE, polygonOptions = FALSE, circleOptions = FALSE, 
                                   circleMarkerOptions = FALSE, markerOptions = FALSE)
  output$map <- renderLeaflet(m)
  
  # Create map proxy to make further changes to existing map
  map_proxy <- reactive(leafletProxy("map"))
  
  CountryMapModuleServer("country_map_module", map_proxy, world_sf,ex_type, rvs)
  BiomeMapModuleServer("biome_map_module", map_proxy, biomes,ex_type, rvs)
  EcorregionMapModuleServer("ecorregion_map_module", map_proxy, ecorregions,ex_type, rvs)
  
  output$Text <- renderText({
    # Fix 2: Access the 'country' column directly from rvs$polySelXY
    if (!is.null(rvs$polySelXY)) {
      paste("Selected countries:", paste(rvs$polySelXY$country, collapse = ", "))
    } else {
      "No countries selected"
    }
  })
}

# Run the Shiny app
shinyApp(ui, server)