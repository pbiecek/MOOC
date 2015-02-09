isCorrect <- ifelse(all(as.character(predkiDlugi$mapping) == c("predkosc", "dlugosc")), 
                    TRUE, FALSE)
comments <- ifelse(!exists("predkiDlugi"), "Brak zmiennej o nazwie predkiDlugi", 
                   ifelse(!("ggplot" %in% class(predkiDlugi)), 
                          "Obiekt predkiDlugi nie jest wykresem w ggplot2", 
                          ifelse(isCorrect, "", 
                                 "To nie jest poprawna odpowiedź")))
