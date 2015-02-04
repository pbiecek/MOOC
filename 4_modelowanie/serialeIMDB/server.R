library(shiny)
library(Hmisc)
library(ggthemes)
library(dplyr)
library(ggplot2)
load("../PISAeurope.rda")

shinyServer(function(input, output) {
  myData <- reactive({
    pisa <- as.data.frame(pisa)
    pisa$grouping <- pisa[,input$svariable]
    avgs <- 
      pisa %>% 
      filter(CNT %in% input$scnts) %>%
      group_by(CNT, grouping) %>%
      summarise(math = wtd.mean(PV1MATH, W_FSTUWT, na.rm=TRUE),
                sd = sqrt(wtd.var(PV1MATH, W_FSTUWT, na.rm=TRUE)),
                n = n(),
                lmath = math - 1.96* sd/sqrt(n),
                umath = math + 1.96* sd/sqrt(n))
    avgs <- na.omit(avgs)
    avgs
  })
  
  output$errorbarPlot <- renderPlot({
    #
    # data preparation
    avgs <- myData()
    #
    pl <- ggplot(avgs, aes(y=math, colour=CNT, x = grouping)) + 
      geom_errorbar(aes(ymin=lmath, ymax=umath), 
                    width=0.2, 
                    position=position_dodge(.2)) +
      geom_point(
        position=position_dodge(.2)) + 
      coord_flip() + 
      theme(panel.grid.major.y=element_blank())
    # plotting
    
    pl + switch(input$scheme,
                      "Grey" = theme_grey(),
                      "Black & white" = theme_bw(),
                      "Tufte" = theme_tufte())
  })
})


# The 'your turn' part:
#
# Add an shiny interface to  your 'PISA story' plot
#
