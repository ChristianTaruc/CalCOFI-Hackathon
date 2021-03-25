ui <- shinyUI(
  fluidPage(
    titlePanel("Channel Islands National Marine Reserve"),
    mainPanel(leafletOutput(map))
  )
)

shinyApp(ui = ui, server = server)


