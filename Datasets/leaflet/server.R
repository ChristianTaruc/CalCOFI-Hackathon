shinyServer(function (input, output) {
  output$map <- renderLeaflet({
   leaflet(krill$Abundance.per.m2) %>%
    setView(lng = -120, lat = 34, zoom = 6) %>%
    addTiles() %<%
  })
})

