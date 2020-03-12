#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(readr)
library(plotly)
library(tidyr)
library(dplyr)
library(leaflet)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    confUrl = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Confirmed.csv"
    dailyPath <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports/"
    confDF <- read_csv(confUrl)
    
    listDates <- as.Date(names(confDF)[5:length(confDF)],"%m/%d/%y")
    listDates <- listDates[order(listDates, decreasing = T)]
    
    output$selectedDate = renderUI({
        selectInput("selectedDate", "Select a date:", listDates)
    })
    
    countries <- unique(confDF$`Country/Region`)
    countries <- countries[order(countries)]
    
    countries <- c("ALL", countries)
    output$counties <- renderUI({
        selectInput("country", "Select a Country:", countries)
    })
    
    output$mapPlot <- renderLeaflet({
        validate(
            need(input$selectedDate, "Select a date!"),
            need(input$country, "Select a country or select ALL!")
        )
        
        selectedDate <- as.Date(input$selectedDate, "%Y-%m-%d")
        
        dateField <- as.character.Date(selectedDate, "%m-%d-%Y")
        
        dailyUrl <- paste0(dailyPath, dateField, ".csv")
        df <- read_csv(dailyUrl)
        df <- df %>%
            mutate(location = sub(", NA", "", paste(`Country/Region`, `Province/State`, sep = ", "))) %>%
            mutate(confPopup = paste0(location, "<br>Confirmed = ", Confirmed,
                                      "<br>Deaths = ", Deaths,
                                      "<br>Recovered = ", Recovered))
        country <- input$country
        if(country != "ALL") {
            df <- filter(df, `Country/Region` == country)
        }
        
        m <- df %>%
            leaflet() %>%
            addTiles() %>%
            addCircleMarkers(lat = ~Latitude, lng = ~Longitude, radius = log(df$Confirmed) + 10,
                             clusterOptions = markerClusterOptions(), popup = df$confPopup)
        
        m
    })
    
    
    
    
    
    
    
    
    
    
    
    

    output$distPlot <- renderPlot({

        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white')

    })

})
