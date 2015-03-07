INSERT INTO course_submissions (user_id, lesson_id, message, status, created_at, content)
VALUES (rand() * 1000, 2, '', 'new', now(), 
'library(PogromcyDanych)
library(dplyr)

maxPredkosc <- koty_ptaki %>% 
  group_by(druzyna) %>% 
  summarise(max(predkosc)) %>% 
  `[`(,2) %>% 
  unlist()');

