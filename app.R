#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
#Import Packages
library(shiny)
library(dplyr)
library(leaflet)
#extras has heatmap
library(leaflet.extras)

#Import Data
krill<-read.csv("krill_data4.csv")
whales<-read.csv("whales_3.csv")
cst_btl<-read.csv("cst_btl_FinalDataset.csv")

#Style
#button_color_css <- "
#DivCompClear, #FinderClear, #EnterTimes{
#/* Change the background color of the update button
#to blue. */
#background: DodgerBlue;
#/* Change the text size to 15 pixels. */
#font-size: 15px;
#}"

#Load Variables

#Find temporal range of data
whales$Date <- as.Date(whales$Date)
whales$Year <-format(whales$Date, format="%Y")
whales$YearMonth <-format(whales$Date, format="%Y-%m-01")
whales$Date <- as.Date(whales$Date)
whales$YearMonth<-as.Date(whales$YearMonth, format = "%Y-%m-%d")
cst_btl$Date<-as.Date(cst_btl$Date, format = "%Y-%m-%d")
year_range = range(whales$Year, na.rm = TRUE)
years = seq(year_range[1], year_range[2], by=1)

# Define UI for application that draws a histogram
ui <- shinyUI(
        pageWithSidebar(
            # Application title
            titlePanel("Whale Location by Biotic & Abiotic Factors"),
            # Sidebar with a slider input for number of bins 
            sidebarPanel(
                titlePanel("Map Settings"),
                # Select which data set to plot
                checkboxGroupInput(inputId = "dataSelector",
                                   label = "Select Factors:",
                                   choices = c("Krill" = "krill", 
                                               "Chlor" = "ChlorA",
                                               "Temperature" = "Tdeg_C",
                                               "Phosphate" = "PO4uM"),
                                   selected = "krill"),
                #Year Selector
                selectInput(inputId = "yearSelector",
                            label = "Select Year",
                            choices = years,
                            selected = 2006,
                            width = "220px"
                ),
                #Month Slider 
                sliderInput(inputId = "monthSlider",
                            label = "Select Month Range",
                            min = 1,
                            max = 12,
                            value = c(1,3),
                            width = "220px"),
            ),
            mainPanel(
                # Show a plot of the generated distribution
                leafletOutput("mymap")
            )
        )
    )

# Define server logic required to draw a histogram
server <- function(input, output) {

    #Get the appropriate year
    getWhales <- reactive({
        #Make sure inputs have been made by user
        req(input$yearSelector)
        req(input$monthSlider)
        req(input$dataSelector)
        #Select the user inputs
        currYear<-input$yearSelector
        minMonth<-input$monthSlider[1]
        maxMonth<-input$monthSlider[2]
        #Create datetime object from user inputs
        minDate<-as.Date(paste(currYear, formatC(minMonth, width=2, flag="0"),"01", sep="-"), format = "%Y-%m-%d")
        maxDate<-as.Date(paste(currYear, formatC(maxMonth, width=2, flag="0"),"01", sep="-"), format = "%Y-%m-%d")
        #Subset Data 
        whales[whales$YearMonth >= minDate & whales$YearMonth <= maxDate, ]
    })
    
    getUData <- reactive({
        req(input$yearSelector)
        req(input$monthSlider)
        req(input$dataSelector)
        #Get date range
        currYear<-input$yearSelector
        minMonth<-input$monthSlider[1]
        maxMonth<-input$monthSlider[2]
        #Create datetime object from user inputs
        minDate<-as.Date(paste(currYear, formatC(minMonth, width=2, flag="0"),"01", sep="-"), format = "%Y-%m-%d")
        maxDate<-as.Date(paste(currYear, formatC(maxMonth, width=2, flag="0"),"01", sep="-"), format = "%Y-%m-%d")
        #Select dataset based on user input 
        if (input$dataSelector == "krill") {
            userData<- krill
        } else {
            userData<-cst_btl
            if (input$dataSelector == "ChlorA") {
                #do something
            }
            else if (input$dataSelector == "Tdeg_C") {
                #do something
            }
            else if (input$dataSelector == "PO4uM") {
                #do something
            }
        }
        userData$YearMonth <-format(userData$Date, format="%Y-%m-01")
        userData[userData$YearMonth >= minDate & userData$YearMonth <= maxDate, ]
    })
    #Create map
    output$mymap <- renderLeaflet({
        leaflet() %>%
            addProviderTiles(providers$Stamen.TonerLite,
                             options = providerTileOptions(noWrap = TRUE)
            ) %>%
            addMarkers(label = getWhales()$group_size,
                       lat = getWhales()$latitude,
                       lng = getWhales()$longitude
            ) %>%
            addCircleMarkers(
                lat = getUData()$Latitude,
                lng = getUData()$Longitude,
                radius = 3 * getUData()$abundance_log,
                stroke = FALSE,
                fillColor = 'Orange'
            )
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
