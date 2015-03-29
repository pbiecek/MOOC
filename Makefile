ifeq ( $(origin knitr_error), undefined )
knitr_error=TRUE
endif
# options(warn)
warn=1

.PHONY: default
default: $(files:=.html)

.PHONY: all
all: $(files:=.html) $(files:=_eng.html)

.PHONY: md
md: $(files:=.md)

.PHONY: txt
txt: $(files:=.txt)

.PHONY: docx
docx: $(files:=.docx)

.PHONY: html
html: $(files:=.html)


.PRECIOUS: $(files:=.md)



ifeq ($(use_code),1)
%.md: %.Rmd
	Rscript -e 'knitr::knit("$<", output="$@")'

%.html: %.Rmd
	Rscript -e 'options(warn=$(warn));library(knitr); opts_chunk$$set(error=$(knitr_error));rmarkdown::render("$<")' | tee $(<:.Rmd=.log) 2>&1
else
%.md: %.Rmd
	Rscript -e 'library(knitr);opts_chunk$$set(eval=FALSE, echo=FALSE, results="hide");knitr::knit("$<", output="$@")'

%.html: %.Rmd
	Rscript -e 'library(knitr);opts_chunk$$set(eval=FALSE, echo=FALSE, results="hide"); library(rmarkdown); rmarkdown::render("$<")'
endif


%.txt: %.md
	pandoc $< -o $@ -t plain

%.docx: %.md
	pandoc -s $< -o $@


wcount: $(files:=.txt)
	wc -m $(files:=.txt) > $@

lcount: $(files:.Rmd=.txt)
	wc -l $(files:=.txt) > $@


stats.txt: wcount lcount
	Rscript -e 'wcount <- read.table("wcount"); lcount <- read.table("lcount"); rval <- data.frame(wcount=wcount[[1]]-lcount[[1]], fname=wcount[[2]]); rval$$strony <- rval$$wcount / 1500; rval$$znakicum <- cumsum(rval$$wcount); rval$$stronycum <- cumsum(rval$$strony); gdata::write.fwf(rval, file="$@")'

slajdy-pl.zip: $(files:=.html)
	zip $@ $^

slajdy-eng.zip: $(files:=_eng.html)
	zip $@ $^

# testy
checks.md:
	echo "# Footers ALL" > $@
	grep -H "footer:" $(files:=.Rmd) $(files:=_eng.Rmd) | sort >> $@
	echo "# Footers PL" >> $@
	grep -H "footer:" $(files:=.Rmd) | sort >> $@
	echo "# Footers ANG" >> $@
	grep -H "footer:" $(files:=_eng.Rmd) | sort >> $@
	echo "# Authors" >> $@
	grep -H "author:" $(files:=.Rmd) $(files:=_eng.Rmd) | sort >> $@
