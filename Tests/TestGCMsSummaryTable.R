library(shiny)
source("GCMsSummaryTableModule.R")

# Read the demo data from CSV files
CMIP6_path <- "data/GCMs_details_CMIP6.csv"
CMIP5_path <- "data/GCMs_details_CMIP5.csv"

# Define the UI for the main app
ui <- fluidPage(
  titlePanel("GCM compareR App"),
  sidebarLayout(
    sidebarPanel(),
    mainPanel(
      GCMsSummaryTableModuleUI("GCMs_summary_CMIP6"),
      GCMsSummaryTableModuleUI("GCMs_summary_CMIP5")
    )
  )
)

# Define the server for the main app
server <- function(input, output, session) {
  # Use the GCMsSummaryTableModule with different data
  
  GCMsSummaryTableModuleServer("GCMs_summary_CMIP6", CMIP6_path)
  
  GCMsSummaryTableModuleServer("GCMs_summary_CMIP5", CMIP5_path)
  
  # ... Other server code ...
}

# Run the Shiny app
shinyApp(ui, server)
