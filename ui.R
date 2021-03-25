shinyUI(
  fluidPage(
    titlePanel("ChannelIslandsNationalMarineSanctuary"),
    mainPanel(leafletOutput("map"))
  )
)
shinyApp(ui = ui, server = server)

ui <- fluidPage(
  titlePanel("Channel Islands National Marine Sanctuary"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("year",
                  "Year",
                  min = 1996
                  max = 2006
                  step = 1
                  sep = ""
                  value = 1996),
  mainPanel(
    leafletOutput("map"),
    dataTableOutput("table")
       )
    )
  )
  shinyApp(ui = ui, server = server)