% -*- mode: c -*-
\input ru_cwebmac.tex

\language=1
\def\pkt{{.}}
\secpagedepth=0

\def\title{Eine minimale Anwendung (\today)}
\def\titlefront{\null\vfill
  \centerline{\titlefont Eine minimale Anwendung}
  \vskip 15pt
  \centerline{(Version vom \today)}
  \vfill}
\def\titleback{\null\vfill\vfill\vfill
\centerline{Copyright \copyright\ 1994$-$2014 Martin Ruppert, alle Rechte vorbehalten.}
}

\def\firstparagraph{Das vollst\"andige Programm}

\let\maybe=\iftrue
%\def\contentspagenumber{1}
\pageno=2
\setpage
\mark{\noexpand\nullsec0{Inhaltsverzeichnis}}
\phantom{dumm1}\vfill\eject
\mark{\noexpand\nullsec0{\firstparagraph}}
%\phantom{dumm2}\vfill\eject

%%%%
%% Aktivierung dieses Macros bewirkt eine eigene Titelseite,
%% deren R\"uckseite enth\"alt den copyright-Vermerk
%% und es geht erst auf S. 5 los
%%%%
%\gtitle={{Inhaltsverzeichnis}} % this running head is reset by starred sections
%\mark{\noexpand\nullsec0{\the\gtitle}}
%\pageno=3\setpage
%\phantom{dumm3}\vfill\eject
%\mark{\noexpand\nullsec0{\firstparagraph}}
%\phantom{dumm4}\vfill\eject
%\def\con{\par\vfill\eject % finish the section names
%  \titlepage
%  \conpages
%  \end
%}

@** \firstparagraph.
@c
#define NPAR 1
#define NRES 0
#define MXIT 10000

#include<stdio.h>
#include<math.h>
#include<time.h>
#include "fevol.c"

@<DefinitionModules@>@;
@<ImplementationModules@>

@i rstrat.w

int xsqare(float x[], long iz, float f[], object*hobj, object**objmge){
    int i=0;
    f[0]=0.0;
    for(i=0;i<1;i++) f[0]+=x[i]*x[i];
    if(f[0]>=1e-10) return(1);
    else return(0);
}

int main(){
    float x[NPAR],s[NPAR],f[NRES+1];
    long izaehl=0;
    struct timespec tp;
    if(clock_gettime(CLOCK_REALTIME,&tp)==0){
      srand((unsigned int)(tp.tv_nsec));
    }else exit(-1);
    rstrat(&strategie);
    x[0]=1.0; 
    s[0]=0.001;
    izaehl=fevol(&xsqare,x,s,NPAR,f,NRES,MXIT);
    printf("\n\nxsqare-Minimierung fertig:\nAnzahl Iterationen = %ld\n",izaehl);
    printf("Wert x=%g\nWert s=%g\nWert f=%g\n",x[0],s[0],f[0]);
}

@** Index.
