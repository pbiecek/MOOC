files=$(filter-out %_eng.Rmd,$(wildcard *.Rmd))
use_code=1

.PHONY: default
default: txt

.PHONY: md
md: $(files:.Rmd=.md)

.PHONY: txt
txt: $(files:.Rmd=.txt)

.PHONY: docx
docx: $(files:.Rmd=.docx)

.PHONY: html
html: $(files:.Rmd=.html)


.PRECIOUS: $(files:.Rmd=.md)



ifeq ($(use_code),1)
%.md: %.Rmd
	Rscript -e 'knitr::knit("$<", output="$@")'

%.html: %.Rmd
	Rscript -e 'rmarkdown::render("$<")'
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


wcount: $(files:.Rmd=.txt)
	wc -m $(files:.Rmd=.txt) > $@

lcount: $(files:.Rmd=.txt)
	wc -l $(files:.Rmd=.txt) > $@

stats.txt: wcount lcount
	Rscript -e 'wcount <- read.table("wcount"); lcount <- read.table("lcount"); rval <- data.frame(wcount=wcount[[1]]-lcount[[1]], fname=wcount[[2]]); rval$$strony <- rval$$wcount / 1500; rval$$stronycum <- cumsum(rval$$strony); gdata::write.fwf(rval, file="$@")'

slajdy-pl.zip: $(files:.Rmd=.html)
	zip $@ $^
