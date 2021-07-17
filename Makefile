default:minibeispiel lingl benchmarks
doc:benchmarks.pdf fevol.pdf lingl.pdf minibeispiel.pdf

%:%.c fevol.c
	clang -Wall -g -o $@ $< -lm
%.c:%.w
	ctangle $<

fevol.h:
fevol.c:fevol.w
	date +%Y%m%d.%H%M%S > ...date
	cp $< $*.`cat ...date`.w
	ctangle $<

benchmarks.c:benchmarks.w fevol.c
	date +%Y%m%d.%H%M%S > ...date
	cp $< $*.`cat ...date`.w
	ctangle $<

benchmarks:benchmarks.c Makefile
	clang -Wall -g -o benchmarks benchmarks.c -lm
	cp -p benchmarks benchmarks.`cat ...date`
#	touch benchmarks
#	nohup benchmarks.`cat ...date` 2>&1 > benchmarks.`cat ...date`.log &
#	benchmarks.`cat ...date` 2>&1 | tee benchmarks.`cat ...date`.log

%.pdf:%.dvi
	dvipdfm $<
	chmod 644 $@
	if [ -z $(DISPLAY) ]; then fbgs $@;else okular $@;fi
%.dvi:%.ltx
	latex $<
	latex $<
	latex $<
%.dvi:%.tex
	tex $<
	mkdir -p .dvi
	dviselect -i $@ -o .dvi/toc.dvi :0
	dviselect -i $@ -o .dvi/pages.dvi 1:
	dviconcat .dvi/toc.dvi .dvi/pages.dvi > $@
	rm -rf .dvi
%.tex:%.w
	cweave $<

PHONY:benchmarks.w clean
clean:
	@delbufiles
	@rm -fv *.o *.c *.cc *.h *.log ...date
	@rm -fv .abest* .best* benchmarks h
	@rm -fv lingl minibeispiel
	@rm -fv *.aux *.dvi *.idx *.pdf
	@rm -fv *.scn *.tex *.toc
