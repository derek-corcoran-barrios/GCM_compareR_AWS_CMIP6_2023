# GCMsSummaryTableModule.R

# Define UI function for combined GCMs summary module
CombinedGCMsSummaryModuleUI <- function(id) {
  ns <- NS(id)
  shiny::tagList(
    uiOutput(ns("GCMs_paragraph")),
    tableOutput(ns("GCMs_table"))
  )
}

# Define server function for combined GCMs summary module
CombinedGCMsSummaryModuleServer <- function(id, gcm_path, gcm_name) {
  moduleServer(
    id,
    function(input, output, session) {
      output$GCMs_paragraph <- shiny::renderUI({
        shiny::tagList(
          hr(),
          h6(gcm_name)
        )
      })
      
      output$GCMs_table <- shiny::renderTable({
        readr::read_csv(gcm_path) |>
          dplyr::select("GCM", "Group acronym", "Modelling group", "Country", "Web")
        
      }, striped = TRUE, hover = TRUE)
    }
  )
}