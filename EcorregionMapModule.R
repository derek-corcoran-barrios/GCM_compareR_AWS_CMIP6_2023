# BiomeMapModule.R

# Define UI function for country selection module
EcorregionMapModuleUI <- function(id) {
  ns <- NS(id)
  shiny::conditionalPanel(
    condition = "input.extent_type == 'map_ecorregions'", 
    ns("extent_type"),
    shiny::selectInput(ns("ext_name_ecorregions"), "Enter ecorregion(s) name(s)",
                       choices = ecorregions$ECO_NAME,
                       multiple = TRUE,selected = NULL)
  )
}


# Define server function for country selection module
EcorregionMapModuleServer <- function(id, map, ecorregions,extent_type, rvs) {
  moduleServer(
    id,
    function(input, output, session) {
      #rvs <- reactiveValues(polySelXY = NULL, saved_bbox = NULL)
      
      observe({
        if (!is.null(extent_type()) && extent_type() == "map_ecorregions") {
          # Country names manually added - subset layer to overlay
          selected_ecorregions <- ecorregions[ecorregions$ECO_NAME %in% input$ext_name_ecorregions,]
          
          map() %>% 
            hideGroup("country") %>% 
            hideGroup("bbox") %>% 
            hideGroup("biomes") %>% 
            clearGroup("draw") %>% 
            clearGroup("countrySel") %>% 
            clearGroup("biomesSel") %>% 
            showGroup("ecorregions") %>% 
            showGroup("ecorregionsSel") %>% 
            addPolygons(data = ecorregions,
                        group = "ecorregions",
                        weight = 1,
                        fillOpacity = 0,
                        opacity = 0.5,
                        # smoothFactor = 3,
                        color = "#595959",
                        popup = ~ECO_NAME,
                        label = ~ECO_NAME,
                        highlightOptions = highlightOptions(color = "#FFA500", weight = 2,
                                                            bringToFront = TRUE)) %>% 
            # Highlight selected ecorregions
            addPolygons(data = sf::st_as_sf(selected_ecorregions), 
                        group = "ecorregionsSel",
                        weight = 1,
                        fillColor = "#8e113f",
                        fillOpacity = 0.4,
                        color = "#561a44")
          
          rvs$polySelXY <- selected_ecorregions
          
          ### Get coordinates for later use to crop and mask GCM rasters
          req(input$map_draw_new_feature)
          coords <- unlist(input$map_draw_new_feature$geometry$coordinates)
          xy <- matrix(c(coords[c(TRUE, FALSE)], coords[c(FALSE, TRUE)]), ncol = 2) %>%
            unique %>%
            terra::ext()
          
          selected_ecorregions <- selected_ecorregions %>%
            terra::crop(xy)
          
          rvs$saved_bbox <- c(xmin(xy), xmax(xy), ymin(xy), ymax(xy))
          rvs$polySelXY <- selected_ecorregions
          return(rvs)
        }
        
      })
    }
  )
}