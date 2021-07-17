% -*- mode:c -*-
\input ru_cwebmac.tex
\secpagedepth=0%
\pageheight=10.0in
\fullpageheight=\pageheight\advance\fullpageheight by 0.25in
\setpage
\def\newpage{\aftergroup\vfill\eject}
\input epsf

\def\pkt{{.}}

\outer\def\N#1#2#3.{\gdepth=#1\ifnum#1<1\gtitle={#3}\fi\MN{#2}% beginning of starred section
  \ifon\ifnum#1<\secpagedepth \vfil\eject % force page break if depth is small
    \else\vfil\penalty-100\vfilneg\vskip\intersecskip\fi\fi
  \message{*\secno} % progress report
  \edef\next{\write\cont{\ZZ{#3}{#1}{\secno}% write to contents file
                   {\noexpand\the\pageno}}}\next % \ZZ{title}{depth}{sec}{page}
  \ifon\startsection{\bf#3.\quad}\ignorespaces}

\def\grouptitle{\let\i=I\let\j=J\expandafter{\expandafter
                        \takethree\topmark}}

\def\fin{\par\vfill\eject % this is done when we are ending the index
  \ifpagesaved\null\vfill\eject\fi % output a null index column
  \if L\lr\else\null\vfill\eject\fi % finish the current page
  \parfillskip 0pt plus 1fil
  \def\grouptitle{Abschnittsnamen}
  \let\topsecno=\nullsec
  \message{Section names:}
  \output={\normaloutput\page\lheader\rheader}
  \setpage
  \def\note##1##2.{\quad{\eightrm##1~##2.}}
  \def\Q{\note{Zitiert in Abschnitt}} % crossref for mention of a section
  \def\Qs{\note{Zitiert in den Abschnitten}} % crossref for mentions of a section
  \def\U{\note{Verwendet in Abschnitt}} % crossref for use of a section
  \def\Us{\note{Verwendet in den Abschnitten}} % crossref for uses of a section
  \def\I{\par\hangindent 2em}\let\*=*
  \readsections}

%%\def\con{\par\vfill\eject % finish the section names
%%  \titlepage
%%  \conpages
%%  \end
%%}
%%\def\titlepage{\par\vfill\eject % finish the section names
%%  \ifodd\pageno\else
%%  \setpage \output={\normaloutput\page\rheader\lheader}
%%  \null\vfill\eject\fi % for duplex printers
%%  \rightskip 0pt \hyphenpenalty 50 \tolerance 200
%%  \setpage \output={\normaloutput\page\lheader\rheader}
%%  \titletrue % prepare to output the titlepage
%%  \pageno=\contentspagenumber
%%  \titlefront
%%  \null\vfill\eject
%%  \setpage \output={\normaloutput\page\lheader\rheader}
%%  \titletrue % prepare to output the titlepage
%%  \titleback}
%%\def\conpages{\par\vfill\eject % finish the \titlepage
%%  \ifodd\pageno\else
%%  \setpage \output={\normaloutput\page\rheader\lheader}
%%  \titletrue\null\vfill\eject\fi % for duplex printers
%%  \rightskip 0pt \hyphenpenalty 50 \tolerance 200
%%  \setpage \output={\normaloutput\page\lheader\rheader}
%%  \titlefalse % prepare to output the table of contents
%%  \def\grouptitle{Inhaltsverzeichnis}
%%  \message{Table of contents:}
%%  \line{\hfil Abschnitt\hbox to3em{\hss Seite}}
%%  \let\ZZ=\contentsline
%%  \readcontents\relax % read the contents info
%%  }
\def\today{\number\day.\space \ifcase\month\or
  Januar\or Februar\or M\"arz\or April\or Mai\or Juni\or
  Juli\or August\or September\or Oktober\or November\or Dezember\fi
  \space \number\year}

\def\uncatcodespecials{\def\do##1{\catcode`##1=12 }\dospecials}
\newcount\lineno %
\def\setupverbatim{\tt \lineno=0
  \obeylines\uncatcodespecials\obeyspaces
%  \everypar{\advance\lineno by1\llap{\the\lineno\ \ }}}
  \everypar{\advance\lineno by1{\the\lineno\ \ }}}
{\obeyspaces\global\let =\ }
\def\listing#1{\par\begingroup\setupverbatim\input#1 \endgroup}

\def\title{Benchmarks f\"ur Evol (Version vom \today)}
\def\titlefront{\null\vfill
  \centerline{\titlefont Evol Benchmarks}
  \vskip 15pt
  \centerline{(Version vom \today)}
  \vfill}
\def\titleback{\null\vfill\vfill\vfill
\centerline{Copyright \copyright\ 1994,2014 Martin Ruppert, alle Rechte vorbehalten.}
}

\def\abs#1{{\tt\char124}#1{\tt\char124}}

\let\maybe=\iftrue
%\def\contentspagenumber{1}
\setpage
\pageno=2
\phantom{Inhaltsverzeichnis S. \the\pageno ist leer, deshalb die Ausgabe dieser
  leeren Seite}
\vfill\eject
%\advance\pageno by 1

@** Einf\"uhrung.

@* Das Hauptprogramm.
@c
#include<stdio.h>
#include<stdlib.h>
#include<time.h>
#include<unistd.h>
#include<math.h>
#include<malloc.h>
#include<limits.h>
#include "fevol.c"

@<DefinitionModules@>
@<ImplementationModules@>

#define NPAR 5
#define NRES 0

@i rstrat.w

@<die Benchmarkfunktionen@>@;

@ @c
int main(){
    int izaehl=0;
    float x[NPAR],s[NPAR],f[NRES+1];
    setlinebuf(stdout);
    strategie.aktiveobjekte=30;
    strategie.besteobjekte=4;
    strategie.maxalter=5*strategie.aktiveobjekte;
    strategie.erfolgsbewertung=1.0;
    strategie.ebmin=1e-14;
    strategie.ebmax=0.1;
    strategie.gradinfo=2.0;
    strategie.zwischenausg=1000;
    strategie.verbessausg=0;
    strategie.maxnoerf=INT_MAX;
    rstrat(&strategie);
    @<Optimiere das lineare Gleichungssystem@>@;
    return(0);
}

@* Das lineare Gleichuungssystem.

@<die Benchmarkfunktionen@>=
int lingl(float x[], long iz, float f[], object*hobj, object**objmge){
  double a,b,c,d,e,g,h;
  a=x[0];b=x[1];c=x[2];d=x[3];e=x[4];
  g=0;
  h=1-a-b-c-d-e;g+=h*h;
  h=a-0.25*a-.5*b-.75*c-.5*d;g+=h*h;
  h=b-.375*a-.5*d;g+=h*h;
  h=c-.25*a-.25*b-.5*e;g+=h*h;
  h=d-.125*a-.25*c;g+=h*h;
  h=e-.25*b-.5*e;g+=h*h;
  f[0]=g;
  if(g>=1e-16) return(1);
  else return(0);
}

@ @<Optimiere das lineare Gleichungssystem@>=
    izaehl=fevol(lingl,x,s,NPAR,f,NRES,20000);

@t\newpage@>

@** Index.
