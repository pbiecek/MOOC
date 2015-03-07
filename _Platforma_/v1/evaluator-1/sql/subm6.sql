INSERT INTO course_submissions (user_id, lesson_id, message, status, created_at, content)
VALUES (rand() * 1000, 3, '', 'new', now(), 
'library(PogromcyDanych)
library(ggplot2)

predkiDlugi <- ggplot(koty_ptaki, aes(predkosc, dlugosc)) + geom_point() + geom_smooth()');

