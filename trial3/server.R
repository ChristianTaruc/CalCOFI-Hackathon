#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
whale <- read_csv("whales_3.csv")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$Plot = renderPlot({
        ggplot(whale) +
            geom_line(mapping = aes(x = years, y = whale[, 7])) +
            labs (x = "Time", y = "Whale Species", title = "Whale") +
            scale_color_discrete(name = "Species")
    })

})
shinyApp(ui = ui, server)

