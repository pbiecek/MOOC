Wizualizacja ggplot 
-------------------

Przetwarzanie danych jest ważne,
modelowanie danych jest ważne,
wnioskowanie danych jest ważne,
ale najważniejszą umiejętnością jest prezentacja zalezności opisywanych przez dane.

Wizualizacja danych nie jest prosta,
aby to poprawnie robić trzeba mieć bardzo szeroki wachlarz umiejętności.
Trzeba rozumieć zależności w danych, ponieważ nie sposób zrobić dobrej grafiki wyjaśniającej coś, jeżeli sami tego nie rozumiemy.
Trzeba znać zasady projektu, nawet najciekawsza historia, bez estetyki, niechluja nie sprawi, że ktokolwiek będzie chciał ją czytać.
Koniec końców, trzeba znać narzędzia poazwalające na automatyczne tworzenie wykresów.

Na dzisiejszych zajęciach zaczniemy pracę z pakietem ggplot, który pozwala na tworznei bardzo czytelnych 
i profesjonalnie wyglądających grafik.

Za cel postawimy sobie przygotowanie czterech wykresów, opisujących zmienne ilościowe, jakościowe, logiczen i tekstowe.









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

