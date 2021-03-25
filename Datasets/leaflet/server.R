shinyServer(function (input, output, session) {
  output$map <- renderLeaflet({
    leaflet(krill_d) %>%
    setView(lng = -120, lat = 34, zoom = 5)
    addProviderTiles("CartoDB.Positron", options = ProviderTileOptions(noWrap = TRUE))
  })
})
