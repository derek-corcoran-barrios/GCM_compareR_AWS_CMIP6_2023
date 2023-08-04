# CMIPSelectionModule.R

# Define UI function for CMIP selection module
# CMIPSelectionModule.R

# Define UI function for CMIP selection module
CMIPSelectionModuleUI <- function(id) {
  ns <- NS(id)
  shiny::fluidRow(
    shiny::column(
      width = 6,
      shiny::selectInput(ns("cmip"), "Choose CMIP Version", 
                         choices = c("cmip6", "cmip5"), 
                         selected = "cmip6"),
      shiny::radioButtons(ns("year_type"), "Year",
                          inline = TRUE,
                          choices = c("2021-2040", "2041-2060", "2061-2080", "2081-2100"),
                          selected = "2081-2100"),
      shiny::radioButtons(ns("scenario_type"), "Shared Socioeconomic Pathway (SSP)",
                          inline = TRUE,
                          choices = c("ssp126", "ssp245", "ssp370", "ssp585"),
                          selected = "ssp245")
    )
  )
}


# Define server function for CMIP selection module
CMIPSelectionModuleServer <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
      observeEvent(input$cmip, {
        if (input$cmip == "cmip6") {
          # Year options for CMIP6
          updateRadioButtons(session, "year_type", 
                             choices = c("2021-2040", "2041-2060", "2061-2080", "2081-2100"),
                             selected = "2081-2100")
          
          # SSP options for CMIP6
          updateRadioButtons(session, "scenario_type", 
                             choices = c("ssp126", "ssp245", "ssp370", "ssp585"),
                             selected = "ssp245")
          
        } else if (input$cmip == "cmip5") {
          # Year options for CMIP5
          updateRadioButtons(session, "year_type", 
                             choices = c("2050", "2070"),
                             selected = "2070")
          
          # RCP options for CMIP5
          updateRadioButtons(session, "scenario_type", 
                             choices = c("rcp26", "rcp45", "rcp60", "rcp85"),
                             selected = "rcp45")
        }
      })
    }
  )
}
