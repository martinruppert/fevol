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

#define NPAR 20
#define NRES 4

@i rstrat.w

@<die Benchmarkfunktionen@>@;

@ @c
int main(){
    int i=0,imin,imax,iq,is=0,izaehl=0,iges=0;
    float x[NPAR],s[NPAR],f[NRES+1],eps[3]={0.0,0.0,0.0};
    setlinebuf(stdout);
    strategie.aktiveobjekte=30;
    strategie.besteobjekte=3;
    strategie.maxalter=5*strategie.aktiveobjekte;
    strategie.erfolgsbewertung=1.0;
    strategie.ebmin=1e-14;
    strategie.ebmax=0.1;
    strategie.gradinfo=1.0;
    strategie.zwischenausg=1000;
    strategie.verbessausg=0;
    strategie.maxnoerf=INT_MAX;
    rstrat(&strategie);
    @<Optimiere $x_0^2+x_1^2$@>@;
    @<Optimiere die Rosenbrock-Klippenfunktion@>@;
    @<Optimiere die Powell-Funktion@>@;
    @<Optimiere die Kreiselmeier-Funktion@>@;
    printf("%d #iges: Gesamtzahl der Iterationen\n",iges);
    return(0);
}

@* Die Benchmarkfunktionen.

@*1 $x_0^2+x_1^2$.
@<die Benchmarkfunktionen@>=
int x0qpx1q(float x[], long iz, float f[], object*hobj, object**objmge){
  int i=0;
  f[0]=0.0;
  for(i=0;i<2;i++) f[0]+=x[i]*x[i];
  if(f[0]>=1e-10) return(1);
  else return(0);
}

@ @<Optimiere $x_0^2+x_1^2$@>=
  eps[1]=1e-14;
  eps[2]=1e-3;
  imin=INT_MAX; imax=0; iq=0;
  for(is=0;is<20;is++){
    x[0]=1.0; s[0]=0.001;
    x[1]=1.0; s[1]=0.001;
    izaehl=fevol(&x0qpx1q,x,s,2,f,0,10000);
    if(izaehl>=0)iges+=izaehl;
    else         iges-=izaehl;
    if(izaehl<imin)imin=izaehl;
    if(izaehl>imax)imax=izaehl;
    iq+=izaehl;
    printf("%d %d #x0^2+x1^2 aktuelle lsg\n",is,izaehl);
  }
  printf("%d %d %d #x0^2+x1^2 Mittelwerte der lsg\n",iq/is,imin,imax);

@*1 Die Funktion von Powell.
@<die Benchmarkfunktionen@>=
int powell(float x[], long iz, float f[], object*hobj, object**objmge){
  float xh1,xh2,xh3,xh4;
  xh1 = x[0] + 10.0*x[1];
  xh1 = xh1 * xh1;
  xh2 = x[2] - x[3];
  xh2 = 5.0 * xh2 * xh2;
  xh3 = x[1] - 2.0*x[2];
  xh3 = xh3 * xh3;
  xh3 = xh3 * xh3;
  xh4 = x[0] - x[3];
  xh4 = xh4 * xh4;
  xh4 = xh4 * xh4;
  xh4 = 10.0 * xh4;
  f[0] = xh1 + xh2 + xh3 + xh4;
  if(f[0]>=1e-10) return(1);
  else return(0);
}

@ @<powell-text@>=
    izaehl=fevol(powell,x,s,4,f,0,20000);
    if(izaehl>=0)iges+=izaehl;
    else         iges-=izaehl;
    if(izaehl<imin)imin=izaehl;
    if(izaehl>imax)imax=izaehl;
    iq+=izaehl;

@ @<Optimiere die Powell-Funktion@>=
#define POWELLS(a,b,c,d) x[0]=a;x[1]=b;x[2]=c;x[3]=d; 
  eps[1]=1e-14;
  eps[2]=1e-3;
  for(i=0;i<4;i++)s[i]=1e-3;
  imin=INT_MAX; imax=0; iq=0;
  for(is=0;is<20;is++){
    POWELLS(3.0,-1.0,0.0,1.0)
    @<powell-text@>@;
    printf("%d %d #powell:3,-1,0,1 aktuelle lsg\n",is,izaehl);
  }
  printf("%d %d %d #powell:3,-1,0,1 Mittelwerte der lsg\n",iq/is,imin,imax);

  for(i=0;i<4;i++)s[i]=1e-3;
  imin=INT_MAX; imax=0; iq=0;
  for(is=0;is<20;is++){
    POWELLS(-1.0,-10.0,0.0,1.0)
    @<powell-text@>@;
    printf("%d %d #powell:-1,-10,0,1 aktuelle lsg\n",is,izaehl);
  }
  printf("%d %d %d #powell:-1,-10,0,1 Mittelwerte der lsg\n",iq/is,imin,imax);

  for(i=0;i<4;i++)s[i]=1e-3;
  imin=INT_MAX; imax=0; iq=0;
  for(is=0;is<20;is++){
    POWELLS(1.0,1.0,1.0,1.0)
    @<powell-text@>@;
    printf("%d %d #powell:1,1,1,1 aktuelle lsg\n",is,izaehl);
  }
  printf("%d %d %d #powell:1,1,1,1 Mittelwerte der lsg\n",iq/is,imin,imax);

  for(i=0;i<4;i++)s[i]=1e-3;
  imin=INT_MAX; imax=0; iq=0;
  for(is=0;is<20;is++){
    POWELLS(10.0,10.0,10.0,10.0)
    @<powell-text@>@;
    printf("%d %d #powell:10,10,10,10 aktuelle lsg\n",is,izaehl);
  }
  printf("%d %d %d #powell:10,10,10,10 Mittelwerte der lsg\n",iq/is,imin,imax);

@*1 Die Rosenbrock'sche Klippenfunktion.
@<die Benchmarkfunktionen@>=
int rosenklippe(float x[], long iz, float f[], object*hobj, object**objmge){
  float xh;
  xh=(x[0]-3.0)/100.0;
  f[0]=xh*xh;
  xh=x[0]-x[1];
  f[0]-=xh;
  if(xh>2.0)xh=2.0;
  f[0]+=exp(20.0*xh);
  if(f[0]<0.199787)return(0);
  else return(1);
}

@ @<Optimiere die Rosenbrock-Klippenfunktion@>=
  eps[1]=1e-14;
  eps[2]=1e-3;
  for(i=0;i<2;i++)s[i]=1e-3;
  imin=INT_MAX; imax=0; iq=0;
  for(is=0;is<20;is++){
    x[0]=0.0;x[1]=-1.0;
    izaehl=fevol(rosenklippe,x,s,2,f,0,2000000);
    if(izaehl>=0)iges+=izaehl;
    else         iges-=izaehl;
    if(izaehl<imin)imin=izaehl;
    if(izaehl>imax)imax=izaehl;
    iq+=izaehl;
    printf("%d %d #rosenklippe:0,-1 aktuelle lsg\n",is,izaehl);
  }
  printf("%d %d %d #rosenklippe:0,-1 Mittelwerte der lsg\n",iq/is,imin,imax);

  for(i=0;i<2;i++)s[i]=1e-3;
  imin=INT_MAX; imax=0; iq=0;
  for(is=0;is<20;is++){
    x[0]=-1.57;x[1]=-1.73;
    izaehl=fevol(rosenklippe,x,s,2,f,0,20000);
    if(izaehl>=0)iges+=izaehl;
    else         iges-=izaehl;
    if(izaehl<imin)imin=izaehl;
    if(izaehl>imax)imax=izaehl;
    iq+=izaehl;
    printf("%d %d #rosenklippe:-1.57,-1.73 aktuelle lsg\n",is,izaehl);
  }
  printf("%d %d %d #rosenklippe:-1.57,-1.73 Mittelwerte der lsg\n",iq/is,imin,imax);

  for(i=0;i<2;i++)s[i]=1e-3;
  imin=INT_MAX; imax=0; iq=0;
  for(is=0;is<20;is++){
    x[0]=0.0;x[1]=0.0;
    izaehl=fevol(rosenklippe,x,s,2,f,0,20000);
    if(izaehl>=0)iges+=izaehl;
    else         iges-=izaehl;
    if(izaehl<imin)imin=izaehl;
    if(izaehl>imax)imax=izaehl;
    iq+=izaehl;
    printf("%d %d #rosenklippe:0,0 aktuelle lsg\n",is,izaehl);
  }
  printf("%d %d %d #rosenklippe:0,0 Mittelwerte der lsg\n",iq/is,imin,imax);

@*1 Die Kreiselmeier-Funktion.
@<die Benchmarkfunktionen@>=
int kreiselfun(float x[], long iz, float f[], object*hobj, object**objmge){
  int i;
  float xh,z[9];
  xh=x[1];
  xh-=x[0]*sin(x[0]);
  z[0]=100.0*xh*xh;
  xh=(x[0]-6.0)/6.0;
  z[0]+=xh*xh;
  for(i=1;i<9;i++)z[i]=x[i+1]-z[i-1];
  f[0]=z[0];
  for(i=1;i<9;i++)f[0]+=z[i]*z[i];
  if(f[0]<1e-10)return(0);
  else return(1);
}

@ @<Optimiere die Kreiselmeier-Funktion@>=
  eps[1]=1e-14;
  eps[2]=1e-3;
  for(i=0;i<9;i++)s[i]=1e-3;
  imin=INT_MAX; imax=0; iq=0;
  for(is=0;is<20;is++){
    x[0]=0.0;x[1]=0.2;x[2]=2.0;
    for(i=3;i<9;i++)x[i]=0.0;
    izaehl=fevol(kreiselfun,x,s,9,f,0,200000);
    if(izaehl>=0)iges+=izaehl;
    else         iges-=izaehl;
    if(izaehl<imin)imin=izaehl;
    if(izaehl>imax)imax=izaehl;
    iq+=izaehl;
    printf("%d %d #kreiselfun: aktuelle lsg\n",is,izaehl);
  }
  printf("%d %d %d #kreiselfun: Mittelwerte der lsg\n",iq/is,imin,imax);

@t\newpage@>

@** Index.
