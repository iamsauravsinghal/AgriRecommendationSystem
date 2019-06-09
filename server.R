library(shiny)
source("croprecommend.R")
source("cropirrigation.R")
shinyServer(function(input, output) {
  output$res<-renderText(ipsystem(input$crop, input$long1,input$lat1,input$month1,input$area))
  output$restable<-renderTable(crsystem(input$soil,input$long,input$lat,input$month))
})
