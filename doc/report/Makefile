all: report.pdf

clean:
	rm -f report.pdf

report.pdf: report.md
	pandoc report.md -V geometry:margin=1in -o report.pdf
