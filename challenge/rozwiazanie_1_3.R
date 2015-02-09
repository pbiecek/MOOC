library(PogromcyDanych)
library(ggplot2)

predkiDlugi <- ggplot(koty_ptaki, aes(predkosc, dlugosc)) + geom_point() + geom_smooth()
