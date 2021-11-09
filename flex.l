%option noyywrap
%{
	#include <stdio.h>
	#include <string.h>
	#include "y.tab.h"
	extern int linea;
	extern void yyerror(char*);
%}

%%

boolean							{return BOOLEAN;}
short							{return SHORT;}
int								{return INT;}
long							{return LONG;}
float							{return FLOAT;}
double							{return DOUBLE;}
char							{return CHAR;}
String							{return STRING;}
def								{return DEF;}
var								{return VAR;}

if								{return IF;}
else							{return ELSE;}
while							{return WHILE;}
do								{return DO;}
for								{return FOR;}

println							{return PRINTLN;}
"System.console().readLine"		{return READ;}

true							{return TRUE;}
false							{return FALSE;}
[0-9]+							{strcpy(yylval.nom, yytext); return NUM;}
[0-9]*\.[0-9]+					{strcpy(yylval.nom, yytext); return NUMR;}
\".*\"							{strcpy(yylval.nom, yytext); return CAD;}

[\ \t]+ 						{;}
\n 								{linea++;}

[a-zA-Z$\_][a-zA-Z0-9\_]*		{strcpy(yylval.nom, yytext); return ID;}
[^a-zA-Z0-9\ \n] 				{return yytext[0];} /* simbolos */


%%