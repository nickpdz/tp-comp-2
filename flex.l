%option noyywrap
%option yylineno
%{
	#include<stdio.h>
	#include"y.tab.h"
%}

%%



boolean												{return BOOLEAN;}
short													{return SHORT;}
int														{return INT;}
long													{return LONG;}
float													{return FLOAT;}
double												{return DOUBLE;}
char													{return CHAR;}
String												{return STRING;}
def														{return DEF;}
var														{return VAR;}

if														{return IF;}
else													{return ELSE;}
while													{return WHILE;}
do														{return DO;}
for														{return FOR;}

println												{return PRINTLN;}
"System.console().readLine"		{return READ;}

true													{return TRUE;}
false													{return FALSE;}
[0-9]+												{return NUM;}
[0-9]*\.[0-9]+								{return NUMR;}
\".*\"												{return CAD;}

[\=\+\-\*\/\<\>\:\(\)\&\{\}\%]	{return yytext[0];}

[a-zA-Z$\_][a-zA-Z0-9\_]*			{return ID;}

\n 														{}
[\ \t\n]+ 										{;}

%%