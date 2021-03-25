server <- function(input, output) {
  output$map <- renderLeaflet({
    krill_ab <- filter(krill,
                       year == input$year,)
  })
}
