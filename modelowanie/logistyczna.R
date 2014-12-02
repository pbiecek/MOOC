





```{r, echo=FALSE}
library(SmarterPoland)
# diagnoza <- osoby[!is.na(osoby$WAGA_2013_OSOBY), c("IMIE_2011",
#           "WAGA_2013_OSOBY",
#           "lata_nauki_2013",
#           "WIEK2013",
#           "PLEC",
#           "województwo",
#           "EDUK4_2013",
#           "status9_2013",
#           "GP3",
#           "GP29",
#           "GP54_01",
#           "GP54_02",
#           "GP54_03",
#           "GP54_04",
#           "GP54_05",
#           "GP54_06",
#           "GP54_07",
#           "GP54_08",
#           "GP54_09",
#           "GP54_10",
#           "GP54_11",
#           "GP54_12",
#           "GP54_13",
#           "GP54_14",
#           "GP54_15",
#           "GP54_16",
#           "GP54_17",
#           "GP54_18",
#           "GP54_19",
#           "GP54_20",
#           "GP54_21",
#           "GP54_22",
#           "GP60","GP61",
#           "GP64",
#           "GP113")]
#save(diagnoza, file="diagnoza.rda")
#diagnozaDict <- osobyDict[colnames(diagnoza),]
#save(diagnozaDict, file="diagnozaDict.rda")

ggplot(diagnoza, aes(x=WIEK2013, fill=GP29)) +
  geom_bar(position="fill")

ggplot(diagnoza[!is.na(diagnoza$GP54_13),], aes(x=WIEK2013, fill=GP54_13)) +
  geom_bar(position="fill") + facet_wrap(~PLEC)

ggplot(diagnoza[!is.na(diagnoza$GP54_01),], aes(x=WIEK2013, fill=GP54_13)) +
  geom_bar(position="fill") + facet_wrap(~PLEC)

ggplot(diagnoza[!is.na(diagnoza$GP54_01),], aes(x=WIEK2013, fill=PLEC)) +
  geom_bar(position="fill") + facet_wrap(~GP54_13)

ggplot(diagnoza[!is.na(diagnoza$GP54_13),], aes(x=WIEK2013, fill=GP54_13)) +
  geom_bar(position="fill")

ggplot(diagnoza, aes(x=WIEK2013, y=GP113)) +
  geom_point() + geom_smooth(se=F, size=3)

ggplot(diagnoza, aes(x=WIEK2013, y=GP64)) +
  geom_smooth(se=F, size=3)

ggplot(diagnoza, aes(x=GP113, y=GP64)) +
  geom_smooth(se=F, size=3)

quantile(diagnoza$GP64, seq(0,1,0.01), na.rm = TRUE)

```

