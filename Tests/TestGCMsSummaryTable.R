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
      CombinedGCMsSummaryModuleUI("Combined_GCMs_summary_CMIP6"),
      CombinedGCMsSummaryModuleUI("Combined_GCMs_summary_CMIP5")
    )
  )
)

# Define the server for the main app
server <- function(input, output, session) {
  # Use the CombinedGCMsSummaryModule with different data
  
  CombinedGCMsSummaryModuleServer("Combined_GCMs_summary_CMIP6", CMIP6_path, "CMIP6")
  CombinedGCMsSummaryModuleServer("Combined_GCMs_summary_CMIP5", CMIP5_path, "CMIP5")
  
  # ... Other server code ...
}

# Run the Shiny app
shinyApp(ui, server)
