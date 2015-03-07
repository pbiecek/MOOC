/* INSERT INTO mytable (myfield) VALUES (CONCAT_WS(CHAR(10 using utf8), 'hi this is some text', 'and this is a line feed', 'and another')); */


INSERT INTO course_lessons (id, course_id, name, type, position, active, expect) VALUES (
1, 1, 'PD', 1, 1, 1, 
'isCorrect <- ifelse(abs(srWiek - 45.5154) < 0.001, TRUE, FALSE)
comments <- ifelse(!exists("srWiek"), "Brak zmiennej o nazwie srWiek", 
                   ifelse(isCorrect, "", 
                          "To nie jest poprawna odpowiedź"))');

INSERT INTO course_lessons (id, course_id, name, type, position, active, expect) VALUES (
2, 1, 'PD', 1, 1, 1, 
'isCorrect <- ifelse(all(maxPredkosc == c(115, 170)), 
                    TRUE, FALSE)
comments <- ifelse(!exists("maxPredkosc"), "Brak zmiennej o nazwie maxPredkosc", 
                   ifelse(isCorrect, "", 
                          "To nie jest poprawna odpowiedź"))');

INSERT INTO course_lessons (id, course_id, name, type, position, active, expect) VALUES (
3, 1, 'PD', 1, 1, 1, 
'isCorrect <- ifelse(all(as.character(predkiDlugi$mapping) == c("predkosc", "dlugosc")), 
                    TRUE, FALSE)
comments <- ifelse(!exists("predkiDlugi"), "Brak zmiennej o nazwie predkiDlugi", 
                   ifelse(!("ggplot" %in% class(predkiDlugi)), 
                          "Obiekt predkiDlugi nie jest wykresem w ggplot2", 
                          ifelse(isCorrect, "", 
                                 "To nie jest poprawna odpowiedź")))');

INSERT INTO course_lessons (id, course_id, name, type, position, active, expect) VALUES (
4, 1, 'PD', 1, 1, 1, 'isCorrect <- TRUE');

INSERT INTO course_lessons (id, course_id, name, type, position, active, expect) VALUES (
5, 1, 'PD', 1, 1, 1, 'isCorrect <- FALSE; comments <- "All wrong!!!"');

