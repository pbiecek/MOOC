isCorrect <- ifelse(all(maxPredkosc == c(115, 170)), 
                    TRUE, FALSE)
comments <- ifelse(!exists("maxPredkosc"), "Brak zmiennej o nazwie maxPredkosc", 
                   ifelse(isCorrect, "", 
                          "To nie jest poprawna odpowiedź"))
