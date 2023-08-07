# Define UI function for Draw selection module
#DrawMapModuleUI <- function(id) {
#  ns <- NS(id)
#}

# Define server function for country selection module
# Define server function for Draw selection module
DrawMapModuleServer <- function(id, map, draw_new, extent_type, rvs) {
  moduleServer(
    id,
    function(input, output, session) {
      observe({
        if (!is.null(extent_type()) && extent_type() == "map_draw") {
          # Show the "draw" group only once when the map is rendered
          map() %>% 
            hideGroup("country") %>% 
            hideGroup("countrySel") %>% 
            hideGroup("biomes") %>% 
            hideGroup("biomesSel") %>% 
            hideGroup("ecorregions") %>% 
            hideGroup("ecorregionsSel") %>% 
            hideGroup("bbox") %>% 
            clearGroup("draw") %>%
            showGroup("draw") 
          
          # Use req() to ensure draw_new() is available before proceeding
          req(draw_new())
          
          # Get coordinates
          coords <- unlist(draw_new()$geometry$coordinates)
          xy <- matrix(c(coords[c(TRUE,FALSE)], coords[c(FALSE,TRUE)]), ncol = 2) %>%
            unique %>% 
            terra::ext()
          rvs$polySelXY <- xy
          rvs$saved_bbox <- xy
        }
      })
    }
  )
}
