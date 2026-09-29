# Build main.pdf. TeX runs in the Docker image named in .texlive-image (via
# scripts/tex); run scripts/setup once per machine. To use a local TeX Live
# instead, set TEX_NATIVE=1 (e.g. make TEX_NATIVE=1).
#
#   make            # build main.pdf (engine and options come from .latexmkrc)
#   make clean      # remove aux files, keep the PDF
#   make distclean  # remove aux files and the PDF

LATEXMK := $(CURDIR)/scripts/tex latexmk

.PHONY: pdf clean distclean

pdf:
	$(LATEXMK)

clean:
	$(LATEXMK) -c

distclean:
	$(LATEXMK) -C
