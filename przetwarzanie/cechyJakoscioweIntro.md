Eksploracja / cechy ilościowe
-----------------------------

Znajomy ostatnio szukał rodzinnego samochodu.
Wiedząc, że intereresowałem się analizą danych dotyczących cen aut, przyszedł z kilkoma pytaniami.

Szukał samochodu rodzinnego, używanego ale niezbyt starego.
Jednak najważniejszym kryterium, była popularność samochodu.
Stwierdził, że kupi samochód, który jest najczęstszy na rynku, dzięki temu nie będzie miał problemu z częściami zamiennymi.

Ok, pomóżmy mu!

Wykorzystamy zbiór danych o ofertach sprzedaży samochodów, by zobaczyć jaka marka, jaki model i który rocznik jest najczęściej oferowany.

A przy okazji poznamy czery z pięciu najważniejszych funkcji do przetwarzania danych.


```{r, warning=FALSE}
library(SmarterPoland)
library(dplyr)

auta2012 %>%
    group_by(Marka) %>%
    summarise(count = n()) %>%
    arrange(desc(count))

auta2012 %>%
    filter(Marka == "Volkswagen") %>%
    group_by(Model) %>%
    summarise(count = n()) %>%
    arrange(desc(count))

auta2012 %>%
    filter(Marka == "Volkswagen",
    Model == "Passat") %>%
    group_by(Rok.produkcji) %>%
    summarise(count = n()) %>%
    arrange(desc(count))

wybrane <-
   auta2012 %>% 
      filter(Marka == "Volkswagen",
      Model == "Passat",
      Rok.produkcji == 2006)

```


