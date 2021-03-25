shinyServer(function (input, output) {
  output$map <- renderLeaflet({
   leaflet(krill$Abundance.per.m2) %>%
    setView(lng = -120, lat = 34, zoom = 6) %>%
    addTiles() %<%
    addCircleMarkers(
      lng = ~krill$Longitude,
      lat = ~krill$Latitude,
      radius = ~krill$Abundance.per.m2,
      stroke = FALSE,
      fillOpacity = 0.5,
    )
  })
})
