INSERT INTO course_submissions (user_id, lesson_id, message, status, created_at, content)
VALUES (rand() * 1000, 1, '', 'new', now(), 
'dat <- read.table("http://biecek.pl/R/dane/daneO.csv", sep=";")
srWiek <- mean(dat$Wiek)');
