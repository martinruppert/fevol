%-*- mode: c;-*-
% Copyright (c) 1980-2015 Martin Ruppert.  All Rights Reserved.
% 
% This program is free software; you can redistribute it and/or modify
% it under the terms of version 2 or any later version of the GNU
% General Public License as published by the Free Software Foundation.
% 
% This program is distributed in the hope that it would be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
% 
% Further, this software is distributed without any warranty that it is
% free of the rightful claim of any third person regarding infringement
% or the like.
% 
% You can get a copy of the GNU General Public License from the Free
% Software Foundation, Inc., 59 Temple Place - Suite 330, Boston MA
% 02111-1307, USA or via Internet.

\def\newpage{\aftergroup\vfill\eject}

%%%Aktivieren, wenn fevol selbstaendig dokumentiert wird
%%\catcode`\ä=\active \catcode`\ö=\active \catcode`\ü=\active
%%\catcode`\Ä=\active \catcode`\Ö=\active \catcode`\Ü=\active
%%\uccode`ä=`Ä        \uccode`ö=`Ö        \uccode`ü=`Ü
%%\catcode`\ß=\active
%%\defä{\"a}\defö{\"o}\defü{\"u}\defÄ{\"A}\defÖ{\"O}\defÜ{\"U}\defß{\ss}
%%
\secpagedepth0
\def\vfej{\vfill\eject}
\def\np{\aftergroup\vfej}
%%
%%\def\tocdepth{4}
%%\def\contentsline#1#2#3#4#5{\ifnum#2<\tocdepth{
%%    \line{\consetup{#2}#1
%%      \rm\leaders\hbox to .5em{.\hfil}\hfil
%%      \ \ifacro\pdflink{#3}{\romannumeral#3}\else#3\fi\hbox to3em{\hss#4}}}\fi}
%%
%%\tolerance=1999
%%\hbadness=\tolerance
%%\hfuzz=3pt
%%\emergencystretch1pt
%%
%%\def\cpyrgt{Copyright \copyright\ 2004 Martin Ruppert, all rights reserved}
%%
%%\def\title{Mehrgliedrige Evolutionstrategie (\today)}
%%\def\topofcontents{\null\vfill
%%  \pageheight6.2in\setpage
%%  \centerline{\titlefont Die mehrgliedrige Evolutionsstrategie}
%%  \bigskip 
%%  \centerline{\titlefont mit impliziter Gradienteninformation}
%%  \bigskip\smallskip
%%  \centerline{(Version vom \today)}
%%  \vfill\eject
%%  \null\vfill
%%  \noindent
%%  \cpyrgt
%%
%%  \bigskip\noindent
%%  This program is free software; you can redistribute it and/or modify
%%  it under the terms of version 2 or any later version of the GNU
%%  General Public License as published by the Free Software Foundation.
%%
%%  \smallskip\noindent
%%  You can get a copy of the GNU General Public License from the Free
%%  Software Foundation, Inc., 59 Temple Place - Suite 330, Boston
%%  MA~02111-1307, USA or via Internet.
%%  \eject
%%}

\def\title{Mehrgliedrige Evolutionsstrategie (Version vom \today)}
\def\titlefront{\null\vfill
  \centerline{\titlefont Die mehrgliedrige Evolutionsstrategie}
  \bigskip
  \centerline{\titlefont mit impliziter Gradienteninformation}
  \vskip 15pt
  \centerline{(Version vom \today)}
  \vfill}
\def\titleback{\null\vfill\vfill\vfill
\centerline{Copyright \copyright\ 1994-2014 Martin Ruppert, alle Rechte vorbehalten.}
}

\def\today{\number\day.\space \ifcase\month\or
  Januar\or Februar\or M\"arz\or April\or Mai\or Juni\or
  Juli\or August\or September\or Oktober\or November\or Dezember\fi
  \space \number\year}

\def\abs#1{{\tt\char124}#1{\tt\char124}}

\let\maybe=\iftrue
%\def\contentspagenumber{1}
\setpage
\pageno=2
\phantom{Inhaltsverzeichnis S. 2 ist leer, deshalb die Ausgabe dieser
  leeren Seite}
\vfej
\pageno=3

@**Die mehrgliedrige Evolutionsstrategie.

@c
@<Includes@>@;
@<DataStructures@>@;
@<GlobalData@>@;
@<DefinitionModules@>@;
@<ImplementationModules@>

@i frandom.w

@ @<Includes@>=
#include<dirent.h>
#include<limits.h>
#include<malloc.h>
#include<math.h>
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<unistd.h>

@*1 Externe Definitionen.
@<DefinitionModules@>=
float pt1(float y, float u, float t);
int tst_file(char*s);

@*1 Die Zielfunktion des Anwenders.
@^Anwenderschnittstelle: Zielfunktion@> 

Die Zielfunktion liefert 0 zur\"uck, wenn das Ziel im
Sinne des Anwenders erf\"ullt ist, sonst $\ne 0$.
  
@<DefinitionModules@>=
int guetefunktion(float x[], long izaehl, float f[],object*hobj,object**objmge);
  /* wenn Ziel erreicht, liefert guetefunktion() 0, sonst != 0 */

@*1 Die Aufrufschnittstelle.
@<DefinitionModules@>=
long fevol(@t\1@>@/
    int    guetefunktion(float x[], long izaehl,float f[],object*hobj,object**objmge),@/
    float x[],   /* x[0..npar-1]   EinAusgabe, Start- und Ergebnisvektor  */
    float s[],   /* s[0..npar-1]   Einausgabe, Streuungsvektor */
    int    npar, /*                Eingabe                     */
    float f[],   /* f[0..nres-1]   R\"uckgabe, Zielf.-vektor   */
    int    nres, /*                Eingabe                     */@t\2@>
    long   imax  /*                Eingabe max. Iter.Zahl      */
  );

@*1 Einstellbare Strategieeigenschaften.
@^Anwenderschnittstelle: Strategieeigenschaften@> 
@<DataStructures@>=
typedef struct strategie_p{
    int aktiveobjekte;
    int besteobjekte;
    int maxalter;
    @<Variablen zur Erfolgsbewertung@>@;
    @<Variablen zur Beeinflussung der Mutationsrate@>@;
    @<Variablen zur Beeinflussung der impliziten 
        Gradienteninformation@>@;
    float startrwdf;
    int zwischenausg;
    int verbessausg;
    long maxnoerf;
    long maxitera;
    long izaehl;
}strategie_p;

@*2 Erfolgsbewertung.

|sollerfolg| ist die gew\"unschte mittlere Erfolgsrate, |erfolg| ist die
\"uber ein diskretes PT1-Glied, dessen Zeitkonstante |tmess|
Iterationen entspricht, dynamisch gemittelte gemessene Erfolgsrate,
und |erfolgsbewer\-tung| ist ein Einflu{\ss}faktor zur
Vergr\"o{\ss}erung oder Verkleinerung der aktuellen Ausdehnung der
Reproduktions\-wahrscheinlichkeitsdichtefunktion in Abh\"angigkeit der
Differenz zwischen |sollerfolg| und |erfolg|.

Wenn |erfolg|$>$|sollerfolg| ist, wird die Ausdehnung vergr\"o{\ss}ert,
um so heftiger, je gr\"o{\ss}er |erfolgsbewertung| ist, und umgekehrt.

@<Variablen zur Erfolgsbewertung@>=
    float sollerfolg;
    float erfolg;
    float erfolgsbewertung;
    float tmess;

@*2 Minimale Mutationsrate.

|eamin| ist die absolute untere Grenze der Streuungen |s_i|, und wird
\"ublicherweise \"uber die betragsm\"a{\ss}ig kleinste darstellbare 
Gleitkommazahl (z.B. 1e-32) f\"ur 32Bit~IEEE~Float Zahlen vorgegeben.

|ebmin| ist die relative untere Grenze der Streuungen |s_i|, und wird
so vorgegeben, da{\ss} |(1.0+|ebmin|)>1.0| wird.  |ebmax| ist die
relative obere Grenze der Streuungen |s_i|, und wird so vorgegeben,
da{\ss} die Deformation der RWDF durch die Dynamik der Streuungen
nicht zu gro{\ss} wird, z.B. |ebmax|$<$10.0.

@<Variablen zur Beeinflussung der Mutationsrate@>=
    float eamin;
    float ebmin;
    float ebmax;

@*2 Implizite Gradienteninformation.

|gradinfo|$=$0.0 bewirkt, da{\ss} keine Gradienteninformation
ber\"ucksichtigt wird, |gradinfo|$>5.0$ ist vermutlich nicht mehr
sinnvoll, meine Empfehlung f\"ur |gradinfo| ist $1.0 {\rm bis} 3.0$.

@<Variablen zur Beeinflussung der impliziten Gradienteninformation@>=
    float gradinfo;

@*2 Vorbelegung der Strategieeigenschaften.
@<GlobalData@>=
struct strategie_p strategie={@t\1@>@/
      30,     /*int aktiveobjekte*/
       3,     /*int besteobjekte*/
     150,     /*int maxalter*/
       0.25,  /*float sollerfolg*/
       0.25,  /*float erfolg*/
       1.0,   /*float erfolgsbewertung*/
    5000,     /*float tmess*/
       1e-30, /*float eamin*/
       1e-7,  /*float ebmin*/
       1e-1,  /*float ebmax*/
       3.0,   /*float gradinfo*/
       1.0,   /*float startrwdf*/
     100,     /*int zwischenausg*/
       1,     /*int verbessausg*/
  100000,     /*long maxnoerf*/@t\2@>
 1000000,     /*long maxitera*/@t\2@>
       0      /*long izaehl*/
};

@*1 Realisierende Funktion |int fevol(...)|.

@<ImplementationModules@>=
long fevol(@t\1@>@/
    int guetefunktion(float x[], long izaehl, float f[],object*hobj,object**objmge),@/
    float x[],      /* x[0..npar-1]   EinAusgabe, Start- und Ergebnisvektor */
    float s[],      /* s[0..npar-1]   Einausgabe, Streuungsvektor */
    int   npar,     /*                Eingabe                     */
    float f[],      /* f[0..nres-1]   R\"uckgabe, Zielf.-vektor   */
    int   nres,     /*                Eingabe                     */
    long  imax      /*                Eingabe max. Iter.Zahl      */
  )@+{
    @<|fevol| lokale Variable@>@;
    @<Generierung und Initialisierung der Startpopulation@>@;
    @<Bewertung des Stammobjektes@>@;
    @<Bewertung der \"ubrigen Eliteobjekte@>@;
    @<Generierung und Bewertung der Restpopulation@>@;
    @<Iterative Ver\"anderung der Population, bis ein Abbruchkriterium
	erf\"ullt ist. Abbruchkriterien sind:
        -~Anwenderkriterium erf\"ullt,
	-~Maximale Iterationszahl |maxitera| erreicht,
	-~Maximale Anzahl erfolglose Versuche |maxnoerf| erreicht@>
  }

@*2 Population aufsetzen.

@<|fevol| lokale Variable@>=
int aktiveobjekte,besteobjekte,i,j,
      objzahl,restriok,suche_weiter;
long lasterf;
long izaehl,izloc,izalt;
  int*indvekt;
  float hif;
  object**objmge;
  object*bobj;
  object*hobj;

@*3 Generierung der Startpopulation.
@<Generierung und Initialisierung der Startpopulation@>=
  aktiveobjekte=strategie.aktiveobjekte;
  besteobjekte=strategie.besteobjekte;
  indvekt=(int*)calloc(aktiveobjekte,sizeof(int));
  for(i=0;i<aktiveobjekte;i++){indvekt[i]=i;}
  allocobj(&bobj,npar,nres);
  allocobj(&hobj,npar,nres);
  objmge=(object**)calloc(aktiveobjekte,sizeof(object*));

@*3 Initialisierung der Startpopulation.
@<Generierung und Initialisierung der Startpopulation@>=
  izaehl=strategie.izaehl;
  izloc=0;
  for(objzahl=0;objzahl<aktiveobjekte;objzahl++){
    objmge[objzahl]=(object*)calloc(1,sizeof(object));
    objmge[objzahl]->maxalter=strategie.maxalter;
    objmge[objzahl]->alter   =strategie.maxalter;
    objmge[objzahl]->parameteranzahl=npar;
    objmge[objzahl]->restriktionsanzahl=nres;
    objmge[objzahl]->streuungen=(float*)calloc(npar,sizeof(float));
    objmge[objzahl]->parameter=(float*)calloc(npar,sizeof(float));
    if(objzahl==0){
      for(i=0;i<npar;i++){
        objmge[objzahl]->streuungen[i]=s[i];
        objmge[objzahl]->parameter[i]=x[i];
      }
    }
    else{
      hif=exp(strategie.startrwdf*(0.5-frandom()));
      for(i=0;i<npar;i++){
        objmge[objzahl]->streuungen[i]=s[i];
        objmge[objzahl]->parameter[i]=x[i]+
          strategie.startrwdf*s[i]*hif*(frandom()-frandom()+frandom()-frandom());
      }
    }
    objmge[objzahl]->guetevektor=(float*)calloc(nres+1,sizeof(float));
  }

@*3 Fitness des Startobjekts.
@<Bewertung des Stammobjektes@>=
  assigno2too1(hobj,objmge[indvekt[0]]);
  suche_weiter = guetefunktion(hobj->parameter,izaehl,hobj->guetevektor,hobj,objmge);
  assigno2too1(objmge[indvekt[0]],hobj);
  assigno2too1(bobj,hobj);
  lasterf=izaehl;
  bobj->alter=0;
  @<Eventuell fertig weil Anwenderkriterium erf\"ullt@>@;

@*3 Fitness der Elite.
@<Bewertung der \"ubrigen Eliteobjekte@>=
  for(objzahl=1;objzahl<strategie.besteobjekte;objzahl++){
    for(j=0;j<objzahl;j++){
      objmge[j]->alter--;
    }
    izaehl++;
    izloc++;
    suche_weiter = guetefunktion(objmge[objzahl]->parameter,izaehl,
      objmge[objzahl]->guetevektor,objmge[objzahl],objmge);
    if(objekt1istbesser(objmge[objzahl],bobj)){
      assigno2too1(bobj,objmge[objzahl]);
      @<eventuell Ausgabe der Verbesserung@>@;
    }
    assigno2too1(hobj,objmge[objzahl]);
    objmge[objzahl]->alter=-1;
    replaceobj(objzahl,indvekt,objzahl,hobj,objmge,izloc);
    @<Eventuell fertig weil Anwenderkriterium erf\"ullt@>@;
  }

@*3 Generierung der Restpopulation.
@<Generierung und Bewertung der Restpopulation@>=
  for(objzahl=strategie.besteobjekte;objzahl<aktiveobjekte;objzahl++){
    for(j=0;j<objzahl;j++){
      objmge[j]->alter--;
    }
    izaehl++;
    izloc++;
    genobject(hobj,&strategie,objzahl,indvekt,objmge);
    @qfuer groessere Varianz:@>
    @qsuche_weiter = guetefunktion(objmge[objzahl]->parameter,izaehl,@>
    @q  objmge[objzahl]->guetevektor,objmge[objzahl],objmge);@>
    suche_weiter = guetefunktion(hobj->parameter,izaehl,
      hobj->guetevektor,hobj,objmge);
    assigno2too1(objmge[objzahl],hobj);
    if(objekt1istbesser(objmge[objzahl],bobj)){
      assigno2too1(bobj,objmge[objzahl]);
      @<eventuell Ausgabe der Verbesserung@>@;
    }
    objmge[objzahl]->alter=-1;
    replaceobj(objzahl,indvekt,objzahl,hobj,objmge,izloc);
    @<Eventuell fertig weil Anwenderkriterium erf\"ullt@>@;
  }

@*2 Iterative Ver\"anderung der Population.
@<Iterative Ver\"anderung der Population...@>=
  do{
    @<Eventuell Aufnahme von anderen Besten@>@;
    @<Generierung eines Nachkommen@>@;
    @<Bewertung des Nachkommen@>@;
    @<Eventuell Ersetzen des aktuell besten Objekts@> @;
    @<Altern, ggf. Einfuegen und Neusortieren der Population@>@;
    @<Anpassen der mittleren Erfolgsrate@>@;
    @<Eventuell fertig weil Anwenderkriterium erf\"ullt@>@;
    @<Eventuell Abbruch weil |imax| oder |maxnoerf| erreicht@>@;
  }while(1);

@*3 Generierung eines Nachkommen.
@<Generierung eines Nachkommen@>=
  izaehl++;
  izloc++;
  genobject(hobj,&strategie,aktiveobjekte,indvekt,objmge);

@*3 Bewertung des Nachkommen.
@<Bewertung des Nachkommen@>=
    suche_weiter = guetefunktion(hobj->parameter,izaehl,hobj->guetevektor,hobj,objmge);

@*3 Globale Verbesserung.
@<Eventuell Ersetzen des aktuell besten Objekts@>=
  if(!objekt1istbesser(bobj,hobj)){
    assigno2too1(bobj,hobj);
    lasterf=izaehl;
    bobj->alter=0;
    @<eventuell Ausgabe der Verbesserung@>@;
  }

@*3 Altern und Neusortieren der Population.
@<|fevol| lokale Variable@>=
int idx,ivj,minalter=0;

@ @<Altern, ggf. Einfuegen und Neusortieren der Population@>=
idx=-1;
minalter=0;
for(j=0;j<aktiveobjekte;j++){
  ivj=indvekt[j];
  objmge[ivj]->alter--;
  if(objmge[ivj]->alter<0){
    if(minalter>objmge[ivj]->alter){
      minalter=objmge[ivj]->alter;
      idx=j;
    }
  }
}
/*sortobjmge(indvekt,aktiveobjekte,objmge);*/
replaceobj(idx,indvekt,objzahl-1,hobj,objmge,izloc);
strategie.erfolg=pt1(strategie.erfolg,0.0,strategie.tmess);

@*3 Anpassen der mittleren Erfolgsrate.
@<Anpassen der mittleren Erfolgsrate@>=
  if(!objekt1istbesser(objmge[indvekt[aktiveobjekte-1]],hobj)){
    if(idx<0){
      strategie.erfolg=pt1(strategie.erfolg,1.0,strategie.tmess);
    }
    else{
      strategie.erfolg=pt1(strategie.erfolg,-1.0,strategie.tmess);
    }
  }

@*3 Ziel erreicht.
@<Eventuell fertig weil Anwenderkriterium erf\"ullt@>=
  restriok=0;
  for(i=1;i<=nres;i++){
    if(bobj->guetevektor[i]!=0.0)restriok++;
  }
  if(restriok==0){
    if(suche_weiter == 0){
      @<eventuell Ausgabe der Verbesserung@>@;
      for(i=0;i<npar;i++){
	x[i]=bobj->parameter[i];
	s[i]=bobj->streuungen[i];
      }
      for(i=0;i<=nres;i++)f[i]=bobj->guetevektor[i];
      printf("# fertig, weil Anwenderkriterium erfuellt.\n");
      return(izaehl); 
    }
  }
  @<eventuell Ausgabe eines Zwischenergebnisses@>@;

@*3 Wir geben auf.
@<Eventuell Abbruch weil |imax| oder |maxnoerf| erreicht@>=
  if(izloc>strategie.maxitera || izaehl-lasterf>strategie.maxnoerf){
    for(i=0;i<npar;i++)x[i]=bobj->parameter[i];
    for(i=0;i<=nres;i++)f[i]=bobj->guetevektor[i];
    printf("# Abbruch, weil imax oder maxnoerf erreicht.\n");
    printf("# izaehl=%ld izloc=%ld imax=%ld lasterf=%ld maxnoerf=%ld maxitera=%ld\n",
	   izaehl,izloc,imax,lasterf,strategie.maxnoerf,strategie.maxitera);
    return(-izaehl);
  }

@ Ausgabe Verbesserung.
@<eventuell Ausgabe der Verbesserung@>=
if(strategie.verbessausg>0){@t\1@>@;
  PVERB(printf("# verbesserung:izaehl=%6ld izloc=%6ld\n",izaehl,izloc);)@;
  PVERB(printf("%ld",izaehl);)@;
  PVERB(@+for(i=0;i<=nres;i++)printf(" %g",bobj->guetevektor[i]);@+)@;
  PVERB(for(i=0;i<=nres;i++))@;
  PVERB(printf(" %g",objmge[indvekt[aktiveobjekte-2]]->guetevektor[i]);)@;
  PVERB(printf(" %g",strategie.erfolg);)@;
  PVERB(printf(" #mevol_verbesserung.ausgabe iz fb[] fs[] erfolg\n");)@;
  @q PVERB(prtobj(bobj);)@>@t\2@>
  fprintobj(".best",npar,izaehl,izloc,bobj);
}

@ Ausgabe Zwischenergebnis.
@<eventuell Ausgabe eines Zwischenergebnisses@>=
if(izaehl%strategie.zwischenausg==0){@t\1@>@;
  PZERG(printf("izaehl=%d Aktuell bestes Objekt:\n",izaehl);)@;
  PZERG(prtobj(objmge[indvekt[0]]);)@;
  PZERG(printf("izaehl=%d Bisher insgesamt bestes Objekt:\n",izaehl);)@;
  PZERG(prtobj(bobj);printf("\n");)@;
  printf("%ld",izaehl);
  for(i=0;i<=nres;i++){
    printf(" %g",objmge[indvekt[0]]->guetevektor[i]);
  }
  for(i=0;i<=nres;i++){
    printf(" %g",objmge[indvekt[aktiveobjekte-1]]->guetevektor[i]);
  } 
  printf(" %g #mevol_verlauf.ausgabe iz fb[] fs[] erfolg\n",
          strategie.erfolg);
  fprintobj(".abest",npar,izaehl,izloc,objmge[indvekt[0]]);
  @t\2@>@;
}


@ Bedinge Ausgabe von Zwischenergebnissen.
@d PVERB(val) val
@d PZERG(val)

@*1 Typdeklarationen: Objekt.
@<DataStructures@>=
typedef struct object_record{
  int maxalter;
  int alter;
  int parameteranzahl;
  int restriktionsanzahl;
  float*streuungen;
  float*parameter;
  float*guetevektor;
}object;

@*1 Prozeduren zur Evolutionsstrategie.
@<ImplementationModules@>=
float pt1(float y, float u, float t){
  if(t!=0)y+=(u-y)/t;
  else y=u;
  return(y);
}

@ @<ImplementationModules@>=
int tst_file(char*s){
  FILE*tst_aus;
  int ret;
  tst_aus=fopen(s,"r");
  if(tst_aus != NULL){
     ret=1;
     fclose(tst_aus);
  }
  else ret=0;
  return(ret);
}

@ allocobj.
@<DefinitionModules@>=
void allocobj(object**hobj,int n,int m);

@ @<ImplementationModules@>=
void allocobj(object**hobj,int n,int m){
  (*hobj)=(object*)calloc(1,sizeof(object));
  (*hobj)->streuungen=(float*)calloc(n,sizeof(float));
  (*hobj)->parameter=(float*)calloc(n,sizeof(float));
  (*hobj)->guetevektor=(float*)calloc(m+1,sizeof(float));
}

@ assigno2too1.
@<DefinitionModules@>=
void assigno2too1(object*o1,object*o2);

@ @<ImplementationModules@>=
void assigno2too1(object*o1,object*o2){
  int i;
  o1->maxalter=o2->maxalter;
  o1->alter=   o2->alter;
  o1->parameteranzahl=o2->parameteranzahl;
  o1->restriktionsanzahl=o2->restriktionsanzahl;
  for(i=0;i<o1->parameteranzahl;i++)
    o1->streuungen[i]=o2->streuungen[i];
  for(i=0;i<o1->parameteranzahl;i++)
    o1->parameter[i]=o2->parameter[i];
  for(i=0;i<=o1->restriktionsanzahl;i++)
    o1->guetevektor[i]=o2->guetevektor[i];
}

@ prtobj. 
@<DefinitionModules@>=
void prtobj(object*obj);

@ @<ImplementationModules@>=
void prtobj(object*obj){
  int i;
  printf("  maxalter=%4d",obj->maxalter); 
  printf(" alter=%4d\n",obj->alter); 
  for(i=0;i<obj->parameteranzahl;i++){
    printf("  x[%1d]=%20.14e;",i,obj->parameter[i]);
    printf(" @@+ s[%1d]=%20.14e;\n",i,obj->streuungen[i]);
  } 
  for(i=0;i<=obj->restriktionsanzahl;i++){
    if((i>0)&&(i%2==0))printf(" @@+");
    printf("  f[%1d]=%20.14e;",i,obj->guetevektor[i]);
    if(i%2==0)printf("\n");
  }
  if(i%2!=1)printf("\n");
}

@ fprintobj. 
@<DefinitionModules@>=
void fprintobj(char*basename,int npar,
	       int izaehl,int izloc,object*obj);

@ @<ImplementationModules@>=
void fprintobj(char*basename,int npar,
  int izaehl,int izloc,object*obj){
  FILE*outfile;
  int i;
  char s[256],s1[256],s2[256],s3[256];
  sprintf(s1,"%s.1",basename);
  sprintf(s2,"%s.2",basename);
  sprintf(s3,"%s.3",basename);
  rename(s2,s3);
  rename(s1,s2);
  rename(basename,s1);
  outfile=fopen(basename,"w");
  if(outfile != NULL){
    @<schreibe das Objekt in die Datei und schlie{\ss}e diese@>
  }
  if(tst_file(".prtbests")){
    sprintf(s,"%s.%07d",basename,izaehl);
    outfile=fopen(s,"w");
    if(outfile != NULL){
      @<schreibe das Objekt in die Datei und schlie{\ss}e diese@>
    }
  }
}

@ @<schreibe das Objekt in die Datei...@>=
  fprintf(outfile,"%d %d\n",npar,izaehl);
  for(i=0;i<obj->parameteranzahl;i++){
    fprintf(outfile,"%d %21.14e %21.14e\n",i,obj->parameter[i],obj->streuungen[i]);
  }
  fprintf(outfile,"#f %07d %07d ",izaehl,izloc);
  for(i=0;i<=obj->restriktionsanzahl;i++){
    fprintf(outfile,"%10g ",obj->guetevektor[i]);
  }
  fprintf(outfile," #%s\n",basename);
  fclose(outfile);

@ printobjmge. 
@<DefinitionModules@>=
void printobjmge(object**objmge,int iv[], int aktiveobj);

@ @<ImplementationModules@>=
void printobjmge(object**objmge,int iv[], int aktiveobj){
  int i,j;
  for(j=0;j<aktiveobj;j++){
    printf("iv[%02d]=%02d\n",j,iv[j]); 
    printf("  omge[%02d]->maxalter=%3d\n",iv[j],objmge[iv[j]]->maxalter); 
    printf("  omge[%02d]->alter=%3d\n",iv[j],objmge[iv[j]]->alter); 
    printf("  omge[%02d]->parameteranzahl=%3d\n",iv[j],objmge[iv[j]]->parameteranzahl);
    for(i=0;i<objmge[iv[j]]->parameteranzahl;i++){
      printf("    omge[%02d]->parameter[%2d]=%12.5e\n",iv[j],i,objmge[iv[j]]->parameter[i]);
    } 
    for(i=0;i<objmge[iv[j]]->parameteranzahl;i++){
      printf("    omge[%02d]->streuungen[%2d]=%12.5e\n",iv[j],i,objmge[iv[j]]->streuungen[i]);
    } 
    printf("  omge[%02d]->restriktionsanzahl=%3d\n",iv[j],objmge[iv[j]]->restriktionsanzahl);
    for(i=0;i<=objmge[iv[j]]->restriktionsanzahl;i++){
      printf("    omge[%02d]->guetevektor[%2d]=%12.5e\n",iv[j],i,objmge[iv[j]]->guetevektor[i]);
    } 
  }
}

@*2 objekt1istbesser.
liefert 1, wenn das Objekt 1 besser ist, 0 sonst.
@<DefinitionModules@>=
int objekt1istbesser(object*obj1, object*obj2);

@ @<ImplementationModules@>=
int objekt1istbesser(object*obj1, object*obj2)
{
  int i;
  if(obj1->alter<0){
    if(obj2->alter>=0)return(0);
  }
  if(obj2->alter<0){
    if(obj1->alter>=0)return(1);
  }
  if(obj1->restriktionsanzahl>0){
    i = 1;
    do{
      if(obj1->guetevektor[i]<obj2->guetevektor[i]){
        return(1);
      }
      else{
        if(obj1->guetevektor[i]>obj2->guetevektor[i])
          return(0);
      }
      i++;
    }while(i<=obj1->restriktionsanzahl);
  }/*if(obj1->restriktionsanzahl>0)*/;
  if(obj1->guetevektor[0]==obj2->guetevektor[0]){
    if(obj1->alter>obj2->alter)return(1); 
    else return(0);
  }          
  else{
    if(obj1->guetevektor[0]<obj2->guetevektor[0])return(1);
     else return(0);
  }
}/*objekt1istbesser;*/

@*2 replaceobj. |replaceobj| ersetzt das alte Objekt an der Stelle
|idx| durch |hobj|, falls $idx\ge 0$ (altes Objekt ist tot), oder das
alte Objekt an der Stelle |objzahl-1|, falls $idx lt 0$ und
|objekt1istbesser(hobj,omjmge[indvekt[objzahl-1]]=true|.

@<DefinitionModules@>=
void replaceobj(int idx,int indvekt[], int objzahl, object *hobj, object**objmge,int izloc);

@
@@d DEBUGreplaceobj
@@d incit(val) it[val]++
@q@@d incit(val)@>
@d incit(val)

@<ImplementationModules@>=
void replaceobj(int idx,int indvekt[], int objzahl, object *hobj, object*objmge[],int izloc)
{
  @<Debug-Variablen fuer replaceobj@>@;
  int io=objzahl;
  int i,il,ir,im;
  int isav=indvekt[io];
  @<Einleitende Debug-Berechnungen und Ausgaben fuer replaceobj@>@;
  if(idx<0){
    if(objekt1istbesser(objmge[isav],hobj)){
      return;
    }
    incit(0);
    il=0;ir=io;
    @<binaere Suche@>@;
    /*Verschiebung*/
    for(i=io;i>il;i--){indvekt[i]=indvekt[i-1];}
    /*Einfuegung und Zuweisung*/
    indvekt[il]=isav;
    assigno2too1(objmge[isav],hobj);
  }else{
    incit(1);
    if((idx>0)&&(idx<io)){
      incit(2);
      isav=indvekt[idx];
      if(objekt1istbesser(objmge[indvekt[idx+1]],hobj)){
        incit(3);
	il=idx+1;ir=io;
	@<binaere Suche@>@;
	/*Verschiebung*/
	for(i=idx;i<ir;i++){indvekt[i]=indvekt[i+1];}
	indvekt[ir]=isav;
	assigno2too1(objmge[isav],hobj);
      }else{
        incit(4);
	if(objekt1istbesser(hobj,objmge[indvekt[idx-1]])){
          incit(5);
	  il=0;ir=idx;
	  @<binaere Suche@>@;
	  /*Verschiebung*/
	  for(i=idx;i>il;i--){indvekt[i]=indvekt[i-1];}
	  indvekt[il]=isav;
	  assigno2too1(objmge[isav],hobj);
	}else{
	  incit(6);
	  /*nur hier einfuegen*/
	  il=ir=isav;
	  assigno2too1(objmge[isav],hobj);
	}
      }
    }else{
      incit(7);
      if(idx==0){
	incit(8);
	isav=indvekt[0];
	il=1;ir=io;
	@<binaere Suche@>@;
	/*Verschiebung*/
	for(i=0;i<ir;i++){indvekt[i]=indvekt[i+1];}
	indvekt[ir]=isav;
	assigno2too1(objmge[isav],hobj);
      }else{
	incit(9);
	isav=indvekt[io];
	il=0;ir=io-1;
	@<binaere Suche@>@;
	/*Verschiebung*/
	for(i=io;i>il;i--){indvekt[i]=indvekt[i-1];}
	indvekt[il]=isav;
	assigno2too1(objmge[isav],hobj);
      }
    }
  } 
  @<Abschliessende Debug-Berechnungen und Ausgaben fuer replaceobj@>@;
}

@ @<binaere Suche@>= 
    do{
      im=(ir+il+1)>>1;
      if(objekt1istbesser(objmge[indvekt[im]],hobj)){
	il=im+1;
      }else{ir=im-1;}
    }while(ir-il>=0);

@ @<Debug-Variablen fuer replaceobj@>=
#ifdef DEBUGreplaceobj
  int it[10];
  int j,ih,iv[objzahl+1],a[objzahl+1];
  float f[objzahl+1];
  FILE*dbg;
#endif

@ @<Einleitende Debug-Berechnungen und Ausgaben fuer replaceobj@>=
#ifdef DEBUGreplaceobj
    for(i=0;i<10;i++){it[i]=0;}
    for(i=0;i<=objzahl;i++){
      ih=indvekt[i];
      iv[i]=ih;
      a[ih]=objmge[ih]->alter;
      f[ih]=objmge[ih]->guetevektor[0];
    }
    for(i=0;i<=objzahl;i++){
      /* sind alle i von 0 bis objzahl vorhanden? */
      im=-1;
      for(j=0;j<=objzahl;j++){
	if(iv[j]==i){
	  im=i;break;
	}
      }
      if(im<0){
	@<Oeffnen von replaceobj.dbg zum Anfuegen@>@;
	fprintf(dbg,"Vorbedingung: Indvektfehler bei %d izloc=%d\n",i,izloc);
	for(j=0;j<=objzahl;j++){
	  im=indvekt[j];
	  fprintf(dbg,"iv[%d]=%d\n",j,im);
	}
	fclose(dbg);
	exit(1);
      }
    }
#endif

@ @<Abschliessende Debug-Berechnungen und Ausgaben fuer replaceobj@>=
#ifdef DEBUGreplaceobj
    for(i=0;i<=objzahl;i++){
      /* sind alle i von 0 bis objzahl vorhanden? */
      im=-1;
      for(j=0;j<=objzahl;j++){
	if(indvekt[j]==i){
	  im=i;break;
	}
      }
      if(im<0){
	@<Oeffnen von replaceobj.dbg zum Anfuegen@>@;
	fprintf(dbg,"Nachbedingung: Indvektfehler bei %d izloc=%d\n",i,izloc);
	for(j=0;j<=objzahl;j++){
	  im=indvekt[j];
	  fprintf(dbg,"iv[%d]=%d\n",j,im);
	}
	fprintf(dbg,"Pfad Spur: il=%d ir=%d ",il,ir);
	for(j=0;j<10;j++){
	  fprintf(dbg,"i%d=%d ",j,it[j]);
	}
	fprintf(dbg,"\n");
	fprintf(dbg,"objmge vorher:\n");
	for(j=0;j<=objzahl;j++){
	  ih=iv[j];
	  fprintf(dbg,"iv[%d]=%d a[%d]=%d f[%d]=%f\n",
		  j,ih,ih,a[ih],ih,f[ih]);
	}
	fprintf(dbg,"hobj:  a....=%d f....=%f\n",
		  hobj->alter,hobj->guetevektor[0]);
	fprintf(dbg,"objmge nachher:\n");
	for(j=0;j<=objzahl;j++){
	  ih=indvekt[j];
	  fprintf(dbg,"iv[%d]=%d a[%d]=%d f[%d]=%f\n",
		  j,ih,ih,objmge[ih]->alter,ih,objmge[ih]->guetevektor[0]);
	}
	fclose(dbg);
	exit(1);
      }
    }
    im=0;
    for(i=0;i<objzahl;i++){
      if(objekt1istbesser(objmge[indvekt[i+1]],objmge[indvekt[i]])){
	im++;
	@<Oeffnen von replaceobj.dbg zum Anfuegen@>@;
	fprintf(dbg,"Nachbedingung: Sortierfehler bei %d izloc=%d\n",i,izloc);
	fprintf(dbg,"iv[%d]=%d iv[%d]=%d o[%d]>o[%d]\n",
		i,indvekt[i],i+1,indvekt[i+1],indvekt[i],indvekt[i+1]);
	fprintf(dbg,"o%02d.a=%-4d o%02d.f0=%10g  ",
		indvekt[i+1],objmge[indvekt[i+1]]->alter,
		indvekt[i+1],objmge[indvekt[i+1]]->guetevektor[0]);
	fprintf(dbg,"o%02d.a=%-4d o%02d.f0=%10g\n",
		indvekt[i],objmge[indvekt[i]]->alter,
		indvekt[i],objmge[indvekt[i]]->guetevektor[0]);
	fprintf(dbg,"Pfad Spur: il=%d ir=%d ",il,ir);
	for(j=0;j<10;j++){
	  fprintf(dbg,"i%d=%d ",i,it[j]);
	}
	fprintf(dbg,"\n");
	fprintf(dbg,"objmge vorher: im=%d\n",im);
	for(j=0;j<=objzahl;j++){
	  ih=iv[j];
	  fprintf(dbg,"ivov[%d]=%d a[%d]=%d f[%d]=%f\n",
		  j,ih,ih,a[ih],ih,f[ih]);
	}
	fprintf(dbg,"hobj:  a....=%d f....=%f\n",
		  hobj->alter,hobj->guetevektor[0]);
	fprintf(dbg,"objmge nachher: im=%d\n",im);
	for(j=0;j<=objzahl;j++){
	  ih=indvekt[j];
	  fprintf(dbg,"ivon[%d]=%d a[%d]=%d f[%d]=%f\n",
		  j,ih,ih,objmge[ih]->alter,ih,objmge[ih]->guetevektor[0]);
	}
	fclose(dbg);
      }
    }
    if(im>0){
      exit(1);
    }
#endif

@ @<Oeffnen von replaceobj.dbg zum Anfuegen@>=
if((dbg=fopen("replaceobj.dbg","a"))==NULL){
  fprintf(stderr,"replaceobj.dbg open error, exiting");
  exit(1);
}

@*2 genobject.
@d DEBUGgenobject(val)
@<DefinitionModules@>=
void genobject(object*hobj,
               strategie_p*strategie,
               int objzahl,
               int indvekt[],
               object*objmge[]);

@ @<ImplementationModules@>=
void genobject(object*hobj,
               strategie_p*strategie,
               int objzahl,
               int indvekt[],
               object*objmge[])
{  
   int i,i1,i2,ih,ifall;
   float deltax,erfq,expvar;
   float xlp=0.0; 
   assigno2too1(hobj,objmge[indvekt[0]]);
   ih=strategie->besteobjekte;
   if(ih>objzahl){ih=objzahl;}
   i1 = random()%ih-random()%ih;
   if(i1<0) i1 = -i1;
   i2 = random()%objzahl;
   if(objekt1istbesser(objmge[indvekt[i2]],objmge[indvekt[i1]])){
     ih=i1;i1=i2;i2=ih;
   }
   erfq=((strategie->erfolg/strategie->sollerfolg)-1.0);
   ifall = random()%3;
   if(ifall==0) xlp=0.0; // keine GradInfo, ParameterEigenschaften gemischt
   if(ifall==1) xlp=0.0; // keine GradInfo, alle ParameterEigenschaften vom Besten
   if(ifall==2){         // GradInfo, alle ParameterEigenschaften vom Besten
       xlp=strategie->gradinfo*(frandom()+frandom()+frandom()+frandom()+frandom()+
            frandom()+frandom()+frandom()+frandom()+frandom()+
           -frandom()-frandom()-frandom()-frandom()-frandom()-frandom());
       if(xlp>0.0)xlp*=0.5;
       xlp*=exp(strategie->gradinfo*erfq);
   }
   expvar=exp((frandom()-frandom())); 
   for(i=0;i<hobj->parameteranzahl;i++){
      deltax=objmge[indvekt[i1]]->streuungen[i]
             *exp(strategie->erfolgsbewertung*erfq);
      if(deltax<strategie->ebmin*fabs(objmge[indvekt[i1]]->parameter[i]))
        deltax=strategie->ebmin*fabs(objmge[indvekt[i1]]->parameter[i]);
      if(deltax>strategie->ebmax*fabs(objmge[indvekt[i1]]->parameter[i]))
        deltax=strategie->ebmax*fabs(objmge[indvekt[i1]]->parameter[i]);
      if(deltax<strategie->eamin)deltax=strategie->eamin;
      objmge[indvekt[i1]]->streuungen[i]=deltax;
      /*
       * mutation streuungen
      */
      if(frandom()<0.5) deltax=objmge[indvekt[i1]]->streuungen[i];
      else deltax=0.5*(objmge[indvekt[i1]]->streuungen[i]+
                  objmge[indvekt[i2]]->streuungen[i]);
      deltax*=expvar;
      if(deltax<strategie->ebmin*fabs(objmge[indvekt[i1]]->parameter[i]))
        deltax=strategie->ebmin*fabs(objmge[indvekt[i1]]->parameter[i]);
      if(deltax>strategie->ebmax*fabs(objmge[indvekt[i1]]->parameter[i]))
        deltax=strategie->ebmax*fabs(objmge[indvekt[i1]]->parameter[i]);
      if(deltax<strategie->eamin)deltax=strategie->eamin;
      hobj->streuungen[i] = deltax;
      /*
       * eigenschaften generieren
      */
      deltax = hobj->streuungen[i]*
          (frandom()+frandom()+frandom()+frandom()+frandom()
          -frandom()-frandom()-frandom()-frandom()-frandom());
      if(ifall == 0){ 
          //eigenschaft mit wahrscheinlichkeit 0.666666 vom besseren elternobjekt
          if(random()%3<2){
              deltax+=objmge[indvekt[i1]]->parameter[i];
          }
          else{
             deltax+=objmge[indvekt[i2]]->parameter[i];
          }
      }
      if(ifall == 1){ 
          // eigenschaft vom besseren elternobjekt
          deltax+=objmge[indvekt[i1]]->parameter[i];
      }
      if(ifall == 2){
          // eigenschaft vom besseren elternobjekt
          deltax+=objmge[indvekt[i1]]->parameter[i];
          // und zus"atzlich GradInfo
          deltax += xlp*(objmge[indvekt[i1]]->parameter[i]
                    -objmge[indvekt[i2]]->parameter[i]);
      }
      hobj->parameter[i]  = deltax;
   }/* for i = 0 to parzahl do */;
   hobj->maxalter = strategie->maxalter;
   hobj->alter = strategie->maxalter;
}/*genobjekt;*/

@ @<DefinitionModules@>=
int readobjekt(object*hobj, long*izaehl, 
	       char*name, strategie_p*strategie );

@ @<ImplementationModules@>=
int readobjekt(object*hobj, long*izaehl, 
	       char*name, strategie_p*strategie ){
  FILE*infile;
  int inpar,iz;
  int i,j;
  char s[256];
  infile=fopen(name,"r");
  if(infile == NULL){
    fprintf(stdout,"FileOpenError: %s\n",name);
    return(-1);
  }
  else{
    fscanf(infile,"%d %d\n",&inpar,&iz);
    if(inpar!=hobj->parameteranzahl){
      fprintf(stdout,"NPAR did not match: %s\n",name);
      fclose(infile);
      unlink(name);
      return(-1);
    }
    for(i=0;i<hobj->parameteranzahl;i++){
      fscanf(infile,"%d %g %g\n",
	     &j,&(hobj->parameter[i]),&(hobj->streuungen[i]));
      if(j!=i){
	fprintf(stdout,"FileReadError: %s\n",name);
	fclose(infile);
	unlink(name);
	return(-1);
      }
    }
    fscanf(infile,"%s ",s);
    fscanf(infile,"%d",&i);
    if(i!=iz){
      fprintf(stdout,"%s: izBegin=%d izEnd=%d\n",name,iz,i);
      fclose(infile);
      unlink(name);
      return(-1);
    }
    fscanf(infile,"%d",&i);
    for(i=0;i<=hobj->restriktionsanzahl;i++){
      fscanf(infile,"%g",&(hobj->guetevektor[i]));
    }
    if(tst_file(".prtueber")){
      printf("%d",iz);
      for(i=0;i<=hobj->restriktionsanzahl;i++){
	printf(" %f",hobj->guetevektor[i]);
      }
      printf(" #mevol_uebernahme.ausgabe:%s\n",name);
    }
    fclose(infile);
    if(iz>(*izaehl))(*izaehl)=iz;
    return(0);
  }
}

@ 
@<|fevol| lokale Variable@>=
  int nn,k;
  struct dirent **objlist;
  char sbuf[256];

@ @<Eventuell Aufnahme von anderen Besten@>=
{
  objlist=NULL;
  nn = scandir (".best.others", &objlist, 0, alphasort);
  if(nn > 2){
    for(i=2;i<nn;i++){
      strcpy(sbuf,".best.others/"); 
      strcat(sbuf,objlist[i]->d_name);
      izalt=izaehl;
      if(readobjekt(hobj,&izaehl,sbuf,&strategie)==0){
        if(izalt<izaehl){lasterf=izaehl;}
        unlink(sbuf);
        hobj->maxalter = strategie.maxalter;
        hobj->alter = strategie.maxalter;
	k=rand()%(aktiveobjekte/7)+3;
	for(j=0;j<=hobj->restriktionsanzahl;j++){
	  hobj->guetevektor[j]=objmge[indvekt[k]]->guetevektor[j];
	}
        /*assigno2too1(objmge[indvekt[aktiveobjekte-1]],hobj);*/
        /*sortobjmge(indvekt,aktiveobjekte,objmge);*/
	idx=-1;
	minalter=0;
	for(j=0;j<aktiveobjekte;j++){
	  ivj=indvekt[j];
	  objmge[ivj]->alter--;
	  if(objmge[ivj]->alter<0){
	    if(minalter>objmge[ivj]->alter){
	      minalter=objmge[ivj]->alter;
	      idx=j;
	    }
	  }
	}
	replaceobj(idx,indvekt,objzahl-1,hobj,objmge,izloc);
      }
    }
  }
  if(objlist != NULL){
    for(i=0;i<nn;i++){
      if(objlist[i] != NULL){
	free((char *)objlist[i]);
      }
    }
  }
}

@t\newpage@>

@** Index.
