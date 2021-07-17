@*1% -*- mode: c;-*-
frandom. 
|frandom| liefert Pseudozufallszahlen zwischen 0.0 und 1.0.

@<DefinitionModules@>=
float frandom(void);

@ rand() kommt aus der |stdlib|.
@<Includes@>=
#include<stdlib.h> 

@ @<ImplementationModules@>=
float frandom(void)
{
  int ihif=rand()%32767;
  float hif=(float)ihif/32768.0;
  return(hif);
}
