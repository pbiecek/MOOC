isCorrect <- ifelse(abs(srWiek - 45.5154) < 0.001, TRUE, FALSE)
comments <- ifelse(!exists("srWiek"), "Brak zmiennej o nazwie srWiek", 
                   ifelse(isCorrect, "", 
                          "To nie jest poprawna odpowiedź"))
