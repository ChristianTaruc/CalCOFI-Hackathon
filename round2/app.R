#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Load packages
library(shiny)
library(shinythemes)
library(dplyr)
library(readr)

# Load data
trend_data <- read_csv("whales_3.csv")

# Define UI
ui <- fluidPage(theme = shinytheme("lumen"),
                titlePanel("Title Panel Draft"),
                sidebarLayout(
                    sidebarPanel(
                        
                        # Select type of trend to plot
                        selectInput(inputId = "common_name", label = strong("Trend index"),
                                    choices = unique(trend_data$common_name),
                                    selected = "Whale?"),
                        
                        # Select date range to be plotted
                        dateRangeInput("date", strong("Date range"), start = "1996-08-16", end = "2006-10-31",
                                       min = "1996-08-16", max = "2006-10-31"),
                        
                        # Select whether to overlay smooth trend line
                        checkboxInput(inputId = "smoother", label = strong("Overlay smooth trend line"), value = FALSE),
                        
                        # Display only if the smoother is checked
                        conditionalPanel(condition = "input.smoother == true",
                                         sliderInput(inputId = "f", label = "Smoother span:",
                                                     min = 0.01, max = 1, value = 0.67, step = 0.01,
                                                     animate = animationOptions(interval = 100)),
                                         HTML("Higher values give more smoothness.")
                        )
                    ),
                    
                    # Output: Description, lineplot, and reference
                    mainPanel(
                        plotOutput(outputId = "lineplot", height = "300px"),
                        textOutput(outputId = "desc"),
                        tags$a(href = "https://www.google.com/finance/domestic_trends", "Source: Google Domestic Trends", target = "_blank")
                    )
                )
)

# Define server function
server <- function(input, output) {
    
    # Subset data
    trend_data <- reactive({
        req(input$date_time)
        validate(need(!is.na(input$date_time[1]) & !is.na(input$date_time[2]), "Error: Please provide both a start and an end date."))
        validate(need(input$date_time[1] < input$date_time[2], "Error: Start date should be earlier than end date."))
        trend_data %>%
            filter(
                group_size == input$group_size,
                date > as.POSIXct(input$date_time[1]) & date_time < as.POSIXct(input$date_time[2]
                ))
    })
    
    
    # Create scatterplot object the plotOutput function is expecting
    output$lineplot <- renderPlot({
        color = "#434343"
        par(mar = c(4, 4, 1, 1))
        plot(x = trend_data()$date_time, y = trend_data()$group_size, type = "l",
             xlab = "Date", ylab = "Whale? Index", col = color, fg = color, col.lab = color, col.axis = color)
        # Display only if smoother is checked
        if(input$smoother){
            smooth_curve <- lowess(x = as.numeric(trend_data()$date_time), y = trend_data()$group_size, f = input$f)
            lines(smooth_curve, col = "#E6553A", lwd = 3)
        }
    })
    
    # Pull in description of trend
    output$desc <- renderText({
        trend_text <- filter(trend_description, group_size == input$group_size) %>% pull(text)
        paste(trend_text, "are these whales?")
    })
}

# Create Shiny object
shinyApp(ui = ui, server = server)
