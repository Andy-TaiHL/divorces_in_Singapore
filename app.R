## Divorce Rates (by Ethnicity and Marriage Duration) in Singapore 2018
## =====================================================================

rm(list=ls())
library(shiny)
data <- read.csv("divorces-under-the-womens-charter-by-ethnic-group-of-couple-and-duration-of-marriage.csv", header=TRUE, na.strings=c(""))
data <- transform(data, year = as.Date(as.character(year), "%Y"))

varList_L1 <- c("Total", "Chinese", "Indians", "Others", "Inter-ethnic")
varList_L2 <- c("Under 5 Years", "5-9 Years", "10-14 Years", "15-19 Years", "20-24 Years", "25-29 Years", "30 Years & Over")


# ========================= the ui and server codes ================================
library(shiny)

ui<- shinyUI(fluidPage(
  titlePanel("Divorce Rates in Singapore by Ethincity and Duration of Marriages"),
  sidebarLayout(
    sidebarPanel(
      # sliderInput("sliderX", "Pick Minimum and Maximum Year", 
      #             min=1980, max=2016, value=2000, step=1, animate=animationOptions(interval=2, loop=TRUE)),
      selectInput("varNames1", "Select Ethnicity", selected = varList_L1[1], varList_L1),
      selectInput("varNames2", "Select Marriage Duration", selected = varList_L2[1], varList_L2)
    ),
    mainPanel(
      h3("Graphs on Divorces in Singapore (1980-2016)"),
      plotOutput("plot1")
    )
  )
))


server <- shinyServer(function(input, output) {

  output$plot1 <- renderPlot({
    y <- data[data$level_1==input$varNames1 & data$level_2==input$varNames2,"value"]
    timeseries <- ts(y, start=1980)
    
    par(mfrow = c(1,2))
    with(data,{
      hist(y, main="Histogram", xlab="Number of Divorces", ylab="Frequency", col="#AB1301")
      plot.ts(timeseries, type="l", main="Time Series Plot", xlab="Years", las=3, ylab="Number of Divorces", col="#09509C", lwd=2)
    })

  })
})


shinyApp(ui=ui, server=server)

