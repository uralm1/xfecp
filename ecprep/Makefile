#

buildsdir = builds


all: ecprep 

ecprep: $(buildsdir)/ecprep.pdf

clean:
	rm -f $(buildsdir)/ecprep.pdf $(buildsdir)/ecprep.fo $(buildsdir)/ecprep.xml
	rm -f rep/ecprep.pdf rep/ecprep.fo rep/ecprep.xml

###
$(buildsdir)/ecprep.pdf: %.pdf: %.fo
$(buildsdir)/ecprep.fo: %.fo: %.xml

###
$(buildsdir)/ecprep.xml: ecprep_template.xml ecprep.pl
	./ecprep.pl ecprep_template.xml > "$@"


###
%.fo: %.xml _pdf.xsl
	xsltproc --nonet _pdf.xsl "$<" > "$@"

%.pdf: %.fo
	/home/sv/fop/fop -c /home/sv/osi/fop.conf -fo "$<" -pdf "$@"
	cp "$@" /var/www/htdocs/t/
