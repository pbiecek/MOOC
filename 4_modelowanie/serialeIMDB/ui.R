library(shiny)

shinyUI(fluidPage(
  titlePanel("My third Shiny app!"),
  sidebarLayout(
    sidebarPanel(
      
      selectInput("svariable", "Choose grouping variable", 
                  choices = list("Number of books" = "ST28Q01", 
                                 "Gender" = "ST04Q01",
                                 "Public school" = "SC01Q01"), 
                  selected = "ST04Q01"),
      
      selectInput("scheme", "Choose theme", 
                  choices = list("Grey", 
                                 "Black & white",
                                 "Tufte"), 
                  selected = "Grey"),
      
      checkboxGroupInput("scnts", 
                  label = h3("Choose countries"), 
                  choices = list("Poland", 
                        "Germany", 
                        "Finland",
                        "Korea",
                        "France",
                        "United Kingdom",
                        "Japan"),
                  selected = c("Poland", "Germany"))
      
    ),
    
    mainPanel(
      plotOutput("errorbarPlot")
    )
  )
))
