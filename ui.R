#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
    titlePanel("Whalestogram"),
    sidebarLayout(
        sidebarPanel(
            selectsizeInput("cnt",
                            "Select Species:",
                            choices = c("Humpback Whale",
                                        "Gray Whale",
                                        "Blue Whale",
                                        "Sei Whale",
                                        "Minke Whale",
                                        "Fin Whale"),
                            selected = "Gray Whale",
                            multiple = TRUE
        ),
        mainPanel(
            plotOutput("plot")
        )
    )
)
