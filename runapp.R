library(shiny)

# Load functions
source("circleFun.R")

# Load modules

source("GCMsSummaryTableModule.R")

# Load app
source("ui.R")
source("server.R")


shinyApp(ui, server)