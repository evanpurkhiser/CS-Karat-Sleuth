all: report.pdf

clean:
	rm -f report.pdf

report.pdf: report.md template.latex
	pandoc report.md -V geometry:margin=1in -V fontsize=12pt --template=template.latex -o report.pdf
