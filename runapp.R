library(shiny)
# Load app
source("ui.R")
source("server.R")

# Load functions
source("circleFun.R")

# Load modules

source("GCMsSummaryTableModule.R")

shinyApp(ui, server)