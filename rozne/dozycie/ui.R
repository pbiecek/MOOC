## ui.R
library(shiny)

shinyUI(pageWithSidebar(
  headerPanel("Dalszy czas trwania życia"),
  
  sidebarPanel(
    sliderInput("mojWiek", "Wybierz obecny wiek", 
                min=1, max=99, value=32),
    sliderInput("cutoff", "Jakie szanse na dożycie", 
                min=0, max=1, value=0.5)
  ),
  
  mainPanel(
    tabsetPanel(id="activetab",
                tabPanel("Wykres",  plotOutput("attrition", height=600, width=800))
    )
  )
))
