library(shiny)
library(quantmod)

shinyUI <- fluidPage(
  br(),
  br(),
  h1(strong("Financial instruments screener using Bollinger Bands"), align = "center"),
  br(),
  title = "Financial instruments screener using Bollinger Bands",
  plotOutput("plot"),
  hr(),
  br(),
  fluidRow(column(2, 
                  offset = 2,
                  textInput("SelectedInstrument", "Symbol of a financial instrument", "SPY"),
                  dateRangeInput("dates", 
                                 "Date range",
                                 start = "2018-05-01", 
                                 end = as.character(Sys.Date())),
                  selectInput("typechart", "Type of Chart", 
                              c ("Linear chart" = "line", "Bar chart" = "bars", "Candlestick chart" = "candlesticks")),
                  br(),
                  checkboxInput("log", "Plot y axis on log scale", 
                                value = FALSE)
  ),
  
  column(2,
         offeset = 5,
         h4(a("Bollinger Bands", href = "https://en.wikipedia.org/wiki/Bollinger_Bands")),
         checkboxInput("Bollinger", "Bollinger Bands", value = FALSE),
         numericInput("N", "Numbers of periods", "20", "1", "183", step = 1),
         numericInput("sd", "Number of standard deviations", "2", "0", "10", step = 1)
  ),
  column(2,
         offeset = 8,
         selectInput("type", "Type of moving average", c("Simple moving average" = "SMA", 
                                                         "Exponential moving average" = "EMA" )),
         selectInput("draw", "Indicator to draw", c("Bollinger Bands" = "bands", 
                                                    "Bollinger %b" = "percent", "Bollinger Bands Width" = "width" )))
  
  
  )
)




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


shinyApp(ui = shinyUI, server = server)