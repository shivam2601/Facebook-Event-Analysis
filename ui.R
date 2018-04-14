library(shiny)
library(plotly)
library(shinythemes)
library(ggplot2)
library(maps)
ui <-fluidPage( 
  tags$head(
    tags$style('#home,#pie,#geo,#cloud{background-color:#007FFF;color:white}')
  ),
  headerPanel("Facebook Event Analyser"),br(),br(),br(),br(),
  sidebarLayout(
    sidebarPanel(
      wellPanel(
        actionButton(inputId = "home", label="Home" , width = "100%")
      ),
      wellPanel(
        actionButton(inputId = "pie", label="Pie Chart" , width = "100%")
      ),
      wellPanel(
        actionButton(inputId = "geo", label="Geo Plot" , width = "100%")
      ),
      wellPanel(
        actionButton(inputId = "cloud", label="Word Cloud" , width = "100%")
      )
      #selectInput(inputId = "param", label = "Select a parameter", choices = colnames(pie_chart_data))
    ),
    mainPanel(
      uiOutput("main")
      #plotlyOutput("donut")
    )
  )
)
