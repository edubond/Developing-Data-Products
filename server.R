library(shiny)
library(quantmod)

server <- function(input, output) {
  
  Chart <- reactive({
    getSymbols(input$SelectedInstrument, src = "yahoo", 
               from = input$dates[1],
               to = input$dates[2],
               auto.assign = FALSE)
  })
  
  output$plot <- renderPlot({
    
    chartSeries(Chart(), theme = chartTheme("black"), 
                type = input$typechart, log.scale = input$log)
    if (input$Bollinger){
      addBBands(n = input$N, sd = input$sd, maType = input$type, draw = input$draw)
    }
  })  
}
