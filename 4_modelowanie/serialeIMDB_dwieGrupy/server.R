library(shiny)
library(ggvis)
#setwd("~/GitHub/MOOC/4_modelowanie/serialeIMDB/")
load("serialeIMDB.rda")

shinyServer(function(input, output) {
  mySerial <- reactive({
    serialeIMDB[serialeIMDB$serial %in% c(input$serial1, input$serial2), ]
  })
  
  output$opis = renderUI({
    ser <- mySerial()
    napis1 <- paste0("http://www.imdb.com/title/",unique(ser$imdbId)[1],"/epdate?ref_=ttep_ql_4")
    napis2 <- paste0("http://www.imdb.com/title/",unique(ser$imdbId)[2],"/epdate?ref_=ttep_ql_4")
    wsp <- lm(ocena~id, ser)$coef
    HTML("Dane o ocenach serialu <b>",unique(as.character(ser$serial))[1],"</b> można pobrać ze strony <br/> <a href='", napis1, "'>",napis1,"</a><br><br>",
         "Dane o ocenach serialu <b>",unique(as.character(ser$serial))[2],"</b> można pobrać ze strony <br/> <a href='", napis2, "'>",napis2,"</a><br><br>",
         "Trend dla tego serialu opisuje prosta o równaniu: <b>", signif(wsp[1], 2), ifelse(wsp[2] > 0, " + ", " "), signif(wsp[2], 2),"*odcinek</b>")
  })
  
  mySerial %>%
    ggvis(x = ~id, y = ~ocena, fill = ~serial) %>%
    group_by(serial) %>%
    layer_text(text := ~nazwa, opacity=0, fontSize:=1) %>%
    layer_points(fillOpacity:=0.8) %>%
    hide_axis("x") %>%
    set_options(width = 640,padding = padding(10, 10, 50, 50)) %>%
    #    scale_numeric("y", domain=c(0, 10)) %>%
    add_axis("x", title = "Numer odcinka", 
             properties = axis_props(
               grid = list(stroke = "white")      
             )) %>% 
    layer_model_predictions(model = "lm") %>%
    add_tooltip(function(data){
      paste0(data$nazwa, "<br>ocena: ",as.character(data$ocena))
    }, "hover") %>%
    bind_shiny("serialPlot")
  
})

