# CountryMapModule.R

# Define UI function for country selection module
CountryMapModuleUI <- function(id) {
  ns <- NS(id)
  shiny::conditionalPanel(
    condition = "input.extent_type == 'map_country'", ns("extent_type"),
    shiny::selectInput(ns("ext_name_country"), "Enter country name(s)",
                       choices = world_sf$country,
                       multiple = TRUE, selected = NULL)
  )
}

# Define server function for country selection module
CountryMapModuleServer <- function(id, map, world_sf,extent_type, rvs) {
  moduleServer(
    id,
    function(input, output, session) {
      #rvs <- reactiveValues(polySelXY = NULL, saved_bbox = NULL)
      
      observe({
        if (!is.null(extent_type()) && extent_type() == "map_country") {
          # Country names manually added - subset layer to overlay
          selected_countries <- world_sf[world_sf$country %in% input$ext_name_country,]
          
          map() %>%
            clearGroup("draw") %>%
            clearGroup("bbox") %>%
            clearGroup("biomes") %>%
            clearGroup("biomesSel") %>%
            clearGroup("ecorregions") %>%
            clearGroup("ecorregionsSel") %>%
            clearGroup("countrySel") %>%
            hideGroup("biomes") %>%
            hideGroup("biomesSel") %>%
            hideGroup("bbox") %>%
            hideGroup("ecorregions") %>%
            hideGroup("ecorregionsSel") %>%
            showGroup("countrySel") %>%
            showGroup("country") %>%
            addPolygons(data = sf::st_as_sf(world_sf),
                        group = "country",
                        weight = 1,
                        fillOpacity = 0,
                        opacity = 0.5,
                        color = "#595959") %>%
            addPolygons(data = sf::st_as_sf(selected_countries),
                        group = "countrySel",
                        weight = 1,
                        fillColor = "#8e113f",
                        fillOpacity = 0.4,
                        color = "#561a44")
          
          rvs$polySelXY <- selected_countries
          
          ### Get coordinates for later use to crop and mask GCM rasters
          req(input$map_draw_new_feature)
          coords <- unlist(input$map_draw_new_feature$geometry$coordinates)
          xy <- matrix(c(coords[c(TRUE, FALSE)], coords[c(FALSE, TRUE)]), ncol = 2) %>%
            unique %>%
            terra::ext()
          
          selected_countries <- selected_countries %>%
            terra::crop(xy)
          
          rvs$saved_bbox <- c(xmin(xy), xmax(xy), ymin(xy), ymax(xy))
          rvs$polySelXY <- selected_countries
          return(rvs)
        }
        
      })
    }
  )
}