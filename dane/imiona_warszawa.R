imiona_warszawa <- read.table("/Users/pbiecek/Dropbox/ProjektCNK/KTR/Imiona/imiona.warszaw.csv", h=T,sep=",")

colnames(imiona_warszawa) <- c("rok","miesiac","liczba","imie","plec")
imiona_warszawa <- imiona_warszawa[,c("imie","plec","rok","miesiac","liczba")]
imiona_warszawa$plec <- factor(imiona_warszawa$plec, labels = c("K","M"))

library(dplyr)
imiona_warszawa <- imiona_warszawa %>% arrange(imie, rok, miesiac)

head(imiona_warszawa)

save(imiona_warszawa, file="imiona_warszawa.rda")

plot(cumsum((imiona_warszawa %>% filter(imie == "Kinga"))[,"liczba"]))
lines(cumsum((imiona_warszawa %>% filter(imie == "Artur"))[,"liczba"]))
lines(cumsum((imiona_warszawa %>% filter(imie == "Jan"))[,"liczba"]))
lines(cumsum((imiona_warszawa %>% filter(imie == "Jakub"))[,"liczba"]))
