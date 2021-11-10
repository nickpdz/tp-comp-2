%{
	#include <stdio.h>
	#include <string.h>
	#include "tds.c"
	void yyerror(char*);
	int yylex(void);
	int linea=1;
%}

/*
	S = sentencias
	D = declaraciones
	A = asignaciones
	IO = input - output
	T = tipos de datos
	DV = data value
	E = expresiones
	C = condiciones
	SEMI = punto y coma

	Gramatica:
	G(P)
	P-> S P | S
	S-> D SEMI | A SEMI | IO SEMI | IF | FOR | WHILE | DO
	D-> T id | T id = DV | T id = E | T id = C
	A-> id = DV | id = E | id = C
	IO-> println DV | println E | System.console().readLine() | System.console().readLine cad
	IF-> if( C ){P ELSE
	ELSE -> } else { P } | }
	FOR-> for(D; C; ID++) {P} || for(D; C; ID--) {P}
	WHILE-> while( C ) {P}
	DO-> do {P} while( C )
	T-> boolean | short | int | long | float | double | char | String | def | var
	DV-> num | numr | id | cad | true | false
	E-> DV + DV | DV - DV | DV / DV | DV * DV | DV % DV | DV ** DV
	C-> DV > DV | DV < DV | DV >= DV | DV <= DV | DV == DV | DV === DV | DV != DV
	SEMI-> ; | ε
*/

%union{
	char nom[20];

	struct{
		char v[12], f[12];
	}cond;
}

%token BOOLEAN SHORT INT LONG FLOAT DOUBLE CHAR STRING DEF VAR ELSE PRINTLN READ
%token <nom> TRUE FALSE NUM NUMR CAD ID IF FOR WHILE DO
%type <nom> e dv
%type <cond> c

%left '+' '-'
%left '*' '/'

%%

p: s p
 | s
 ;

s: d semi
 | a semi
 | io semi
 | if
 | for
 | while
 | do
 ;

d: t ID									{/*printf("\nSent: Declaracion simple");*/}
 | t ID '=' dv							{/*printf("\n%s = %s", $1, $4);*/}
 | t ID '=' e							{/*printf("\n%s = %s", $1, $4);*/}
 | t ID '=' c							{/*printf("\n%s = %s", $1, $4);*/}
 ;

a: ID '=' dv							{printf("\n%s = %s", $1, $3);}
 | ID '=' e								{printf("\n%s = %s", $1, $3);}
 | ID '=' c								{printf("\n%s = %s", $1, $3);}
 ;

io: PRINTLN dv							{printf("\noutput %s", $2);}
 | PRINTLN e							{printf("\noutput %s", $2);}
 | READ CAD								{printf("\ninput %s", $2);}
 | READ '(' ')'							{printf("\ninput()");}
 ;

if: IF									{nueva_etq($1);}
 '(' c ')'								{printf("\n%s", $4.v);}
 '{' p									{
											printf("\ngoto %s", $1);
											printf("\n%s", $4.f);
										}
 else									{printf("\n%s", $1);}
;

else: '}' ELSE '{' p '}'
 | '}'
 ;

for:FOR '(' d ';' c ';' ID '+' '+' ')' '{' p '}'	{printf("\nSent: FOR");}
 | FOR '(' d ';' c ';' ID '-' '-' ')' '{' p '}'		{printf("\nSent: FOR");} 
 ;

while: WHILE							{
											nueva_etq($1);
											printf("\n%s", $1);
										}
 '(' c ')'								{printf("\n%s", $4.v);}
 '{' p '}'								{
											printf("\ngoto %s", $1);
											printf("\n%s", $4.f);
										}
 ;

do: DO									{
											nueva_etq($1);
											printf("\n%s", $1);
										}
 '{' p '}' WHILE '(' c ')'				{
											printf("\n%s", $8.v);
											printf("\ngoto %s", $1);
											printf("\n%s", $8.f);
										}
 ;

t: BOOLEAN								{/*printf("\nTipo de dato BOOLEAN");*/}
 | SHORT								{/*printf("\nTipo de dato SHORT");*/}
 | INT									{/*printf("\nTipo de dato INT");*/}
 | LONG									{/*printf("\nTipo de dato LONG");*/}
 | FLOAT								{/*printf("\nTipo de dato FLOAT");*/}
 | DOUBLE								{/*printf("\nTipo de dato DOUBLE");*/}
 | CHAR									{/*printf("\nTipo de dato CHAR");*/}
 | STRING								{/*printf("\nTipo de dato STRING");*/}
 | DEF									{/*printf("\nTipo de dato automatico con DEF");*/}
 | VAR									{/*printf("\nTipo de dato automatico con VAR");*/} 
 ;

dv: NUM									{strcpy($$, $1);}
 | NUMR									{strcpy($$, $1);}
 | ID									{strcpy($$, $1);}
 | CAD									{strcpy($$, $1);}
 | TRUE									{strcpy($$, "true");}
 | FALSE								{strcpy($$, "false");}
 ;

e: dv '+' dv							{
											nueva_tmp($$);
											printf("\n%s = %s + %s", $$, $1, $3);
										}
 | dv '-' dv							{
											nueva_tmp($$);
											printf("\n%s = %s - %s", $$, $1, $3);
										}
 | dv '/' dv							{
											nueva_tmp($$);
											printf("\n%s = %s / %s", $$, $1, $3);
										}
 | dv '*' dv							{
											nueva_tmp($$);
											printf("\n%s = %s * %s", $$, $1, $3);
										}
 | dv '%' dv							{
											nueva_tmp($$);
											printf("\n%s = %s % %s", $$, $1, $3);
										}
 | dv '*' '*' dv						{
											nueva_tmp($$);
											printf("\n%s = %s ** %s", $$, $1, $4);
										}
 | '(' e ')'							{strcpy($$, $2);}
 ;

c: dv '>' dv							{
											nueva_etq($$.v);
											nueva_etq($$.f);
											printf("\nif %s > %s goto %s", $1, $3, $$.v);
											printf("\ngoto %s", $$.f);
										}
 | dv '<' dv							{
											nueva_etq($$.v);
											nueva_etq($$.f);
											printf("\nif %s < %s goto %s", $1, $3, $$.v);
											printf("\ngoto %s", $$.f);
										}
 | dv '>' '=' dv						{
											nueva_etq($$.v);
											nueva_etq($$.f);
											printf("\nif %s >= %s goto %s", $1, $4, $$.v);
											printf("\ngoto %s", $$.f);
										}
 | dv '<' '=' dv						{
											nueva_etq($$.v);
											nueva_etq($$.f);
											printf("\nif %s <= %s goto %s", $1, $4, $$.v);
											printf("\ngoto %s", $$.f);
										}
 | dv '=' '=' dv						{
											nueva_etq($$.v);
											nueva_etq($$.f);
											printf("\nif %s == %s goto %s", $1, $4, $$.v);
											printf("\ngoto %s", $$.f);
										}
 | dv '=' '=' '=' dv					{
											nueva_etq($$.v);
											nueva_etq($$.f);
											printf("\nif %s === %s goto %s", $1, $5, $$.v);
											printf("\ngoto %s", $$.f);
										}
 | dv '!' '=' dv						{
											nueva_etq($$.v);
											nueva_etq($$.f);
											printf("\nif %s != %s goto %s", $1, $4, $$.v);
											printf("\ngoto %s", $$.f);
										}
 ;

semi: %empty							{}
 | ';'									{}
 ;

%%

void main(){
	printf("Compiladores II - Trabajo practico\n");
	printf("Lenguaje: Groovy\n");
	yyparse();
	printf("\n\n\tTraduccion a tercetos finalizada.");
}

void yyerror(char *s){
	printf("\n%s, en linea nro: %d", s, linea);
}