Eksploracja / cechy ilościowe
-----------------------------

Jak już wiecie, znajomy ostatnio szukał rodzinnego samochodu.

Pomogliśmy mu sprawdzić, jaki model, jaka marka i jaki rocznik jest najpopularniejszy
i dzięki temu już wie, że szuka 6 letniego Passata.

Nie wie jeszcze ile taki samochod kosztuje.
Mając ceny ofertowe może sprawdzić jaka jest rozpiętość ofertowa cen, dzięki czemu łatwiej będzie mu negocjować ewentualny zakup.

Pomóżmy mu sprawdzić, ile taki samochód kosztuje.

```{r, warning=FALSE}
library(SmarterPoland)
library(dplyr)

wybrane <-
   auta2012 %>% 
      filter(Marka == "Volkswagen",
      Model == "Passat",
      Rok.produkcji == 2006)

hist(wybrane$Cena.w.PLN,50,col="grey")

quantile(wybrane$Cena.w.PLN,seq(0,1,0.1))

plot(ecdf(wybrane$Cena.w.PLN))
abline(h=seq(0,1,0.1))
abline(v=quantile(wybrane$Cena.w.PLN,seq(0,1,0.1)))


hist(wybrane$Przebieg.w.km,50,col="grey")

quantile(wybrane$Cena.w.PLN,seq(0,1,0.1))


plot(wybrane$Cena.w.PLN, wybrane$Przebieg.w.km, log="xy", xlim=c(20000,70000),
ylim=c(50000,400000))

```

