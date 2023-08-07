# BiomeMapModule.R

# Define UI function for country selection module
BiomeMapModuleUI <- function(id) {
  ns <- NS(id)
    shiny::conditionalPanel(
      condition = "input.extent_type == 'map_biomes'", 
      ns("extent_type"),
      shiny::selectInput(ns("ext_name_biomes"), "Enter biome(s) name(s)",
                         choices = biomes$BIOME_NAME,
                         multiple = TRUE,selected = NULL)
    )
}




# Define server function for country selection module
BiomeMapModuleServer <- function(id, map, biomes,extent_type, rvs) {
  moduleServer(
    id,
    function(input, output, session) {
      #rvs <- reactiveValues(polySelXY = NULL, saved_bbox = NULL)
      
      observe({
        if (!is.null(extent_type()) && extent_type() == "map_biomes") {
          # Country names manually added - subset layer to overlay
          selected_biomes <- biomes[biomes$BIOME_NAME %in% input$ext_name_biomes,]
          
          map() %>% 
            hideGroup("country") %>% 
            hideGroup("bbox") %>% 
            # hideGroup("draw") %>% 
            hideGroup("ecorregions") %>% 
            clearGroup("draw") %>%
            clearGroup("country") %>% 
            clearGroup("countrySel") %>% 
            clearGroup("ecorregions") %>% 
            clearGroup("ecorregionsSel") %>% 
            clearGroup("biomesSel") %>% 
            showGroup("biomesSel") %>% 
            showGroup("biomes") %>% 
            addPolygons(data = sf::st_as_sf(biomes),
                        group = "biomes",
                        weight = 1,
                        fillOpacity = 0,
                        opacity = 0.5,
                        color = "#595959",
                        popup = ~BIOME_NAME,
                        label = ~BIOME_NAME,
                        highlightOptions = highlightOptions(color = "#FFA500", weight = 2,
                                                            bringToFront = TRUE)) %>%
            addPolygons(data = sf::st_as_sf(selected_biomes),
                        group = "biomesSel",
                        weight = 1,
                        fillColor = "#8e113f",
                        fillOpacity = 0.4,
                        color = "#561a44")
          
          rvs$polySelXY <- selected_biomes
          
          ### Get coordinates for later use to crop and mask GCM rasters
          req(input$map_draw_new_feature)
          coords <- unlist(input$map_draw_new_feature$geometry$coordinates)
          xy <- matrix(c(coords[c(TRUE, FALSE)], coords[c(FALSE, TRUE)]), ncol = 2) %>%
            unique %>%
            terra::ext()
          
          selected_biomes <- selected_biomes %>%
            terra::crop(xy)
          
          rvs$saved_bbox <- c(xmin(xy), xmax(xy), ymin(xy), ymax(xy))
          rvs$polySelXY <- selected_biomes
          return(rvs)
        }
        
      })
    }
  )
}