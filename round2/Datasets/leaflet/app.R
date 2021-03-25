library(leaflet)
m <- leaflet() %>%
  addTiles() %>%
  addMarkers(lng = -120, lat = 34)
m
