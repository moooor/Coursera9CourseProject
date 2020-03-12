#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("This is corona virus COVID-19 data."),
    p("All you need is just to select a Date and/or a Country to see a result of corona virus stats."),
    p("Or you can use interactive map to zoom in/out to/from particular locations/clusters."),
    p("The data is based on data collected by John Hopkins CSSE. https://github.com/CSSEGISandData/COVID-19"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            uiOutput("selectedDate"),
            uiOutput("counties")
        ),

        # Show a plot of the generated distribution
        mainPanel(
            leafletOutput("mapPlot", width = "800px", height = "600px")
        )
    )
))
