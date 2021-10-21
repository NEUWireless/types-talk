all: slides.pdf

slides.pdf: slides.md
	pandoc -f markdown -t beamer -o slides.pdf slides.md

.PHONY: clean
clean:
	rm -f slides.pdf
