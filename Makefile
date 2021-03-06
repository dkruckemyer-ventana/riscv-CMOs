SPEC=cmobase
DATE=$(shell date  +%Y%m%d)
VERSION=$(shell git describe --tag --always --dirty)

$(SPEC)-$(VERSION).pdf:  $(SPEC)/$(SPEC).adoc \
			 $(SPEC)/*.adoc \
			 $(SPEC)/insns/*.adoc \
			 $(SPEC)/autogenerated/revision.adoc-snippet
	asciidoctor-pdf -r asciidoctor-diagram \
			-D . \
			-a toc \
			-a compress \
			-a pdf-style=resources/themes/risc-v_spec-pdf.yml \
			-a pdf-fontsdir=resources/fonts \
			-o $@ \
			$<
	gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/printer -sOutputFile=opt-$@ $@ && mv opt-$@ $@

DATE=$(shell date  +%Y.%m.%d)
VERSION=$(shell git describe --tag --always --dirty)
COMMITDATE=$(shell git show -s --format=%ci | cut -d ' ' -f 1)

$(SPEC)/autogenerated:
	-mkdir $@

STAGE ?= "This document is in the Development state. Assume anything can change."

$(SPEC)/autogenerated/revision.adoc-snippet: Makefile $(SPEC)/autogenerated FORCE
	echo ":revdate: ${COMMITDATE}" > $@-tmp
	echo ":revnumber: ${VERSION}" >> $@-tmp
	echo ":revremark: ${STAGE}" >> $@-tmp
	diff $@ $@-tmp || mv $@-tmp $@

clean:
	rm -f $(SPEC)-*.pdf

FORCE: 

