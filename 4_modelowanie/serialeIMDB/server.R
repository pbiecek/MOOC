library(shiny)
library(ggvis)
#setwd("~/GitHub/MOOC/4_modelowanie/serialeIMDB/")
load("serialeIMDB.rda")

shinyServer(function(input, output) {
  mySerial <- reactive({
    serialeIMDB[serialeIMDB$serial == input$serial, ]
  })
  
  output$mytable = renderDataTable({
    mySerial()[,c("nazwa", "sezon", "odcinek","ocena", "glosow")]
  })
  
  output$opis = renderUI({
    napis <- paste0("http://www.imdb.com/title/",mySerial()$imdbId[1],"/epdate?ref_=ttep_ql_4")
    HTML("Dane o ocenach tego serialu można pobrać ze strony <a href='", napis, "'>",napis,"</a><br><br>",
         )
  })
  
  mySerial %>%
    ggvis(x = ~id, y = ~ocena, fill = ~sezon) %>%
    layer_text(text := ~nazwa, opacity=0, fontSize:=1) %>%
    layer_points(fillOpacity:=0.8) %>%
    hide_legend("fill") %>%
    hide_axis("x") %>%
    set_options(width = 800,padding = padding(10, 10, 50, 50)) %>%
#    scale_numeric("y", domain=c(0, 10)) %>%
    add_axis("x", title = "Numer odcinka", 
             properties = axis_props(
      grid = list(stroke = "white")      
    )) %>% layer_model_predictions(model = "lm") %>%
    add_tooltip(function(data){
      paste0(data$nazwa, "<br>ocena: ",as.character(data$ocena))
    }, "hover") %>%
    bind_shiny("serialPlot")

})

