library(shiny)
source("CMIPSelectionModule.R")

# Define the UI for the main app
ui <- fluidPage(
  titlePanel("GCM compareR App"),
  sidebarLayout(
    sidebarPanel(
            CMIPSelectionModuleUI("CMIP_selection")
    ),
    mainPanel(
      # Your other UI elements go here...
    )
  )
)

# Define the server for the main app
server <- function(input, output, session) {
  # Use the CMIPSelectionModule
  CMIPSelectionModuleServer("CMIP_selection")
  
  # ... Other server code ...
}

# Run the Shiny app
shinyApp(ui, server)
