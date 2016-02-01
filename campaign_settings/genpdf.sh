#!/bin/bash

#go through each folder in src and generate that document
for DIRNAME in `find src/* -type d`
do
	#get the files we're working with
	DOCNAME=`basename $DIRNAME`
	DOC_PDF=$DOCNAME".pdf"
	DOC_MKD=$DOCNAME".md"
	
	#remove any old copies laying around
	rm "output/$DOC_MKD" 2> /dev/null
	rm "output/$DOC_PDF" 2> /dev/null
	

	#add the metadata file if it exists
	if [ -f "src/$DOC_MKD" ]; then
		cat "src/$DOC_MKD" >> "output/$DOC_MKD"
	fi

	#pop the template on the front
	if [ -f template_begin.tex ]; then	
		cat template_begin.tex >> "output/$DOC_MKD"
	fi

	#add section by section
	for SECTION in `find $DIRNAME/*`
	do
		echo '\cleardoublepage'
		echo ''
		cat "$SECTION"
		echo ''
	done >> "output/$DOC_MKD"

	#add the end template
	if [ -f template_end.tex ]; then
		cat template_end.tex >> "output/$DOC_MKD"
	fi

	#generate the final document
	pandoc --latex-engine xelatex -V header-includes:'\setmainfont[BoldFont = Quattrocento-Bold, ItalicFont = LiberationSerif-Italic, BoldItalicFont = LiberationSerif-BoldItalic]{Quattrocento-Regular}' -f markdown "output/$DOC_MKD" -o "output/$DOC_PDF"
done

