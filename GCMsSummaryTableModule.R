# GCMsSummaryTableModule.R

# Define UI function for GCMs summary table module
GCMsSummaryTableModuleUI <- function(id) {
  ns <- NS(id)
  shiny::tableOutput(ns("GCMs_table"))
}

# Define server function for GCMs summary table module
GCMsSummaryTableModuleServer <- function(id, gcm_path) {
  moduleServer(
    id,
    function(input, output, session) {
      output$GCMs_table <- shiny::renderTable({
        readr::read_csv(gcm_path) |>
          dplyr::select("GCM", "Group acronym", "Modelling group", "Country", "Web")
        
      }, striped = TRUE, hover = TRUE)
    }
  )
}
