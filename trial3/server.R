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

    output$Plot <- renderPlot({

        # generate bins based on input$bins from ui.R
        x    <- whale[, 5]
        y <- whale[, 7] 

        # draw the histogram with the specified number of bins
        plot(x, y)

    })

})

