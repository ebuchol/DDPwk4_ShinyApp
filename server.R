#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(MASS)
data(whiteside); ws <- whiteside

# Define server logic required to fit gas consumption models
shinyServer(function(input, output) {
    fitA <- lm(Gas ~ Temp, data = ws[ws$Insul == "After",])
    fitB <- lm(Gas ~ Temp, data = ws[ws$Insul == "Before",])
    
    modelA <- reactive({
        tempInput <- input$sliderTemp
        if(input$checkFahr) {
            tempInput <- (tempInput - 32)/1.8
        }
        predict(fitA, newdata = data.frame(Temp = tempInput))
    })
    modelB <- reactive({
        tempInput <- input$sliderTemp
        if(input$checkFahr) {
            tempInput <- (tempInput - 32)/1.8
        }
        predict(fitB, newdata = data.frame(Temp = tempInput))
    })
   
  output$plot1 <- renderPlot({
      tempInput <- input$sliderTemp
      if(input$checkFahr) {
          tempInput <- (tempInput - 32)/1.8
      }
      
      # generate plot with predicted points from slider input in ui.R
      plot(ws$Temp[ws$Insul == "Before"], ws$Gas[ws$Insul == "Before"],
           xlab = "Average Temperature (degrees Celsius)",
           ylab = "Weekly Gas Consumption (1000 cubic feet)",
           xlim = c(-15, 16), ylim = c(0, 15),
           col = "black", bty = "n", pch = 16)
      points(ws$Temp[ws$Insul == "After"], ws$Gas[ws$Insul == "After"],
             col = "green", pch = 16)
      abline(fitA, col = "red", lwd = 2)
      abline(fitB, col = "blue", lwd = 2)
      if(tempInput < 16) {
          points(tempInput, modelA(), col = "red", pch = 19, cex = 2)
          points(tempInput, modelB(), col = "blue", pch = 19, cex = 2)
      }
      legend(0, 14, c("Data: without insulation", "Data: with insulation",
                       "Model: without insulation", "Model: with insulation"),
             pch = 16, col =c("black", "green", "blue", "red"),
             bty = "n", cex = 1.5)
  })
  
  output$predB <- renderText({
      ifelse(modelB() > 0, round(modelB() * 1000, 2),
             "Do you really need gas heating at this temperature?")
  })
  
  output$predA <- renderText({
      ifelse(modelA() > 0, round(modelA() * 1000, 2),
             "Do you really need gas heating at this temperature?")
  })
  
  output$savings <- renderText({
      ifelse(modelA() > 0, round((modelB() - modelA()) * 1000, 2),
             "There is no reduction in gas consumption because gas heating is not necessary.")
  })
  
})
