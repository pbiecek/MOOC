library(PogromcyDanych)
library(dplyr)

maxPredkosc <- koty_ptaki %>% 
  group_by(druzyna) %>% 
  summarise(max(predkosc)) %>% 
  `[`(,2) %>% 
  unlist()
