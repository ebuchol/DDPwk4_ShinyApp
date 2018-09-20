#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(MASS)
data(whiteside); ws <- whiteside

# Define UI for application that plots gas consumption versus temperature
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Predicted Household Gas Consumption with and without Cavity Wall Insulation"),
  
  # Sidebar with slider input for temperature, unit specification,
  # and submit button
  sidebarLayout(
    sidebarPanel(
       p("Documentation: Cavity wall insulation can significantly reduce heat
         loss during cold weather."),
       p("First, select the desired temperature in the slider."),
       p("Next, check the box if you want to use Fahrenheit (F) instead of Celsius (C)."),
       p("Finally, click the Submit button."),
       p("The app will display the predicted weekly gas consumption with and without
         insulation along with the gas savings from using cavity wall insulation.
         (based on the whiteside dataset in the MASS package in R)"),
       em("Note: Temperatures below -15 C/5 F or above 15 C/60 F will not display in the plot."),
       h3("Slider Input:"),
       sliderInput("sliderTemp",
                   "What is the average external temperature?",
                   min = -20,
                   max = 65,
                   value = 0),
       checkboxInput("checkFahr",
                     "Check box if Temperature is in degrees Fahrenheit",
                     value = FALSE),
       submitButton("Submit")
    ),
    
    
    # Show plot and predictions for Gas Consumption versus Temperature
    mainPanel(
       plotOutput("plot1"),
       h3("Predicted Weekly Gas Consumption without Insulation (cubic feet):"),
       textOutput("predB"),
       h3("Predicted Weekly Gas Consumption with Insulation (cubic feet):"),
       textOutput("predA"),
       h3("Predicted Reduction in Gas Consumpton using Insulation (cubic feet):"),
       textOutput("savings")
    )
  )
))
