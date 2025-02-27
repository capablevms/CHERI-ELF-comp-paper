.SUFFIXES: .tex .ps .pdf .svg

.svg.pdf:
	inkscape --export-pdf=$@ $<

LATEX_FILES = paper.tex

DIAGRAMS =

all: paper.pdf

clean:
	rm -rf paper.aux paper.bbl paper.blg paper.dvi paper.log paper.ps paper.pdf paper.toc paper.out paper.snm paper.nav paper.vrb paper_preamble.fmt paper_preamble.log texput.log

paper.pdf: bib.bib local.bib ${LATEX_FILES} ${DIAGRAMS} paper_preamble.fmt
	pdflatex paper.tex
	bibtex paper
	pdflatex paper.tex
	pdflatex paper.tex

paper_preamble.fmt: paper_preamble.tex
	set -e; \
	  tmptex=`mktemp`; \
	  cat ${@:fmt=tex} > $${tmptex}; \
	  grep -v "%&${@:_preamble.fmt=}" ${@:_preamble.fmt=.tex} >> $${tmptex}; \
	  pdftex -ini -jobname="${@:.fmt=}" "&pdflatex" mylatexformat.ltx $${tmptex}; \
	  rm $${tmptex}

bib.bib: softdevbib/softdev.bib local.bib
	softdevbib/bin/prebib softdevbib/softdev.bib > bib.bib
	softdevbib/bin/prebib local.bib >> bib.bib

softdevbib-update: softdevbib
	cd softdevbib && git pull

softdevbib/softdev.bib: softdevbib

softdevbib:
	git clone https://github.com/softdevteam/softdevbib.git
