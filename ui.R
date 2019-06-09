library(shinydashboard)
library("sqldf")
cd<-read.csv("capstonecrop.csv")
dr<-sqldf("SELECT DISTINCT Soil FROM cd")
dr1<-sqldf("SELECT DISTINCT Type FROM cd")
dashboardPage(
  dashboardHeader(title="Smart Farming Solution"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Crop Recommmender", tabName = "crs", icon = icon("tree")),
      menuItem("Irrigation Provision", tabName = "ips", icon = icon("tint"))
    )
  ),
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "ips",
              h3("Irrigation Provisioning System"),
              fluidRow(
                box(
                  title="Please input the following informations:",
                  box(numericInput("long1", "Longitude:", 80, min = 1, max = 100),
                      selectInput("crop", "Crop:",
                                  dr1$Type),
                      numericInput("area", "Area in sq. meter:",1, min = 1, max = 100)),
                  box(numericInput("lat1", "Latitude:", 10.26, min = 1, max = 100),
                      selectInput("month1", "Growing Month:",
                                  c("January" = 1,
                                    "February" = 2,
                                    "March" = 3,
                                    "April"=4,"May"=5,"June"=6,"July"=7,"August"=8,"September"=9,"October"=10,"November"=11,"December"=12
                                  ))),
                  submitButton("Submit", icon("refresh"))
                  
                ),
                box(
                  title="Result",
                  verbatimTextOutput("res")
                )
              ) 
      ),
      
      # Second tab content
      tabItem(tabName = "crs",
              h3("Crop Recommendation System"),
              fluidRow(
                box(
                  title="Please input the following informations:",
                  box(numericInput("long", "Longitude:", 80, min = 1, max = 100),
                      selectInput("soil", "Soil Type:",
                                  dr$Soil)),
                  box(numericInput("lat", "Latitude:", 10.26, min = 1, max = 100),
                      selectInput("month", "Growing Month:",
                                  c("January" = 1,
                                    "February" = 2,
                                    "March" = 3,
                                    "April"=4,"May"=5,"June"=6,"July"=7,"August"=8,"September"=9,"October"=10,"November"=11,"December"=12
                                  ))),
                  submitButton("Submit", icon("refresh"))

                ),
                box(
                  title="Result",
                  tableOutput("restable")
                )
              )
      )
    )
  )
)
