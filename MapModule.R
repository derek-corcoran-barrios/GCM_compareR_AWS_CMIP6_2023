# MapModuleUI.R

# Define UI function for the map module
MapModuleUI <- function(id) {
  ns <- NS(id)
  fluidPage(
    titlePanel("Country Selection App"),
    CountryMapModuleUI("country_map_module"),
    BiomeMapModuleUI("biome_map_module"),
    EcorregionMapModuleUI("ecorregion_map_module"),
    radioButtons(
      inputId = ns("extent_type"),
      label = NULL,
      choices = c(
        "Select drawing a rectangle over the map" = "map_draw",
        "Select by country/countries" = "map_country",
        "Select by biome(s)" = "map_biomes",
        "Select by ecorregion(s)" = "map_ecorregions",
        "Enter bounding-box coordinates" = "map_bbox"
      )
    ),
    leafletOutput(ns("map"))
  )
}

# MapModuleServer.R

# Define server function for the map module
MapModuleServer <- function(id, world_sf, biomes, ecorregions) {
  moduleServer(
    id,
    function(input, output, session) {
      rvs <- reactiveValues()
      rvs$polySelXY <- NULL
      rvs$saved_bbox <- NULL
      
      ex_type <- reactive(input$extent_type)
      draw_new <- reactive(req(input$map_draw_new_feature))
      
      # Create a leaflet map
      m <- leaflet(sf::st_as_sf(world_sf)) %>% 
        addTiles() %>%
        addProviderTiles("Esri.WorldPhysical", group = "Relieve") %>%
        addTiles(options = providerTileOptions(noWrap = TRUE), group = "Countries") %>%
        addLayersControl(baseGroups = c("Relieve", "Countries"),
                         options = layersControlOptions(collapsed = FALSE)) %>% 
        setView(0, 0, zoom = 2) %>% 
        leaflet.extras::addDrawToolbar(
          targetGroup = 'draw', 
          singleFeature = TRUE,
          rectangleOptions = filterNULL(list(
            shapeOptions = drawShapeOptions(fillColor = "#8e113f", color = "#595959")
          )),
          polylineOptions = FALSE, polygonOptions = FALSE, circleOptions = FALSE, 
          circleMarkerOptions = FALSE, markerOptions = FALSE
        )
      output$map <- renderLeaflet(m)
      
      # Create map proxy to make further changes to existing map
      map_proxy <- reactive(leafletProxy("map"))
      
      CountryMapModuleServer("country_map_module", map_proxy, world_sf, ex_type, rvs)
      BiomeMapModuleServer("biome_map_module", map_proxy, biomes, ex_type, rvs)
      EcorregionMapModuleServer("ecorregion_map_module", map_proxy, ecorregions, ex_type, rvs)
      DrawMapModuleServer("draw_map_module", map_proxy, draw_new, ex_type, rvs)
    }
  )
}
