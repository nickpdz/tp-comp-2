%define parse.error verbose
%{
	#include <stdio.h>
	#include <string.h>
	#include "tds.c"
	void yyerror(char*);
	int yylex(void);
	extern int yylineno;
%}

/*
	S = sentencias
	D = declaraciones
	A = asignaciones
	IO = input - output
	T = tipos de datos
	E = expresiones
	C = condiciones
	SEMI = punto y coma

	Gramatica:
	G(P)
	P-> S P | S
	S-> D SEMI | A SEMI | IO SEMI | IF | WHILE | DO
	D-> T id | T id = E
	A-> id = E
	IO-> println E | System.console().readLine() | System.console().readLine cad
	IF-> if( C ){P ELSE
	ELSE -> } else { P } | }
	WHILE-> while( C ) {P}
	DO-> do {P} while( C )
	T-> boolean | short | int | long | float | double | char | String | def | var
	E-> E + E | E - E | E / E | E * E | E ** E | (E) | num | numr | id | cad | true | false
	C-> E > E | E < E | E >= E | E <= E | E == E | E === E | E != E
	SEMI-> ; | ε
*/

%union{
	char nom[20];

	struct{
		char v[12], f[12];
	}cond;
}

%token BOOLEAN SHORT INT LONG FLOAT DOUBLE CHAR STRING DEF VAR ELSE PRINTLN READ
%token <nom> TRUE FALSE NUM NUMR CAD ID IF WHILE DO
%type <nom> e
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
 | while
 | do
 | error
 ;

d: t ID
 | t ID '=' e							{printf("\n%s = %s", $2, $4);}
 ;

a: ID '=' e								{printf("\n%s = %s", $1, $3);}
 ;

io: PRINTLN e							{printf("\noutput %s", $2);}
 | READ '(' ')'							{printf("\ninput()");}
 | READ CAD								{printf("\ninput %s", $2);}
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

t: BOOLEAN
 | SHORT
 | INT
 | LONG
 | FLOAT
 | DOUBLE
 | CHAR
 | STRING
 | DEF
 | VAR
 ;

e: e '+' e								{
											nueva_tmp($$);
											printf("\n%s = %s + %s", $$, $1, $3);
										}
 | e '-' e								{
											nueva_tmp($$);
											printf("\n%s = %s - %s", $$, $1, $3);
										}
 | e '/' e								{
											nueva_tmp($$);
											printf("\n%s = %s / %s", $$, $1, $3);
										}
 | e '*' e								{
											nueva_tmp($$);
											printf("\n%s = %s * %s", $$, $1, $3);
										}
 | e '*' '*' e							{
											nueva_tmp($$);
											printf("\n%s = %s ** %s", $$, $1, $4);
										}
 | '(' e ')'							{strcpy($$, $2);}
 | NUM									{strcpy($$, $1);}
 | NUMR									{strcpy($$, $1);}
 | ID									{strcpy($$, $1);}
 | CAD									{strcpy($$, $1);}
 | TRUE									{strcpy($$, "true");}
 | FALSE								{strcpy($$, "false");}
 ;

c: e '>' e								{
											nueva_etq($$.v);
											nueva_etq($$.f);
											printf("\nif %s > %s goto %s", $1, $3, $$.v);
											printf("\ngoto %s", $$.f);
										}
 | e '<' e								{
											nueva_etq($$.v);
											nueva_etq($$.f);
											printf("\nif %s < %s goto %s", $1, $3, $$.v);
											printf("\ngoto %s", $$.f);
										}
 | e '>' '=' e							{
											nueva_etq($$.v);
											nueva_etq($$.f);
											printf("\nif %s >= %s goto %s", $1, $4, $$.v);
											printf("\ngoto %s", $$.f);
										}
 | e '<' '=' e							{
											nueva_etq($$.v);
											nueva_etq($$.f);
											printf("\nif %s <= %s goto %s", $1, $4, $$.v);
											printf("\ngoto %s", $$.f);
										}
 | e '=' '=' e							{
											nueva_etq($$.v);
											nueva_etq($$.f);
											printf("\nif %s == %s goto %s", $1, $4, $$.v);
											printf("\ngoto %s", $$.f);
										}
 | e '=' '=' '=' e						{
											nueva_etq($$.v);
											nueva_etq($$.f);
											printf("\nif %s === %s goto %s", $1, $5, $$.v);
											printf("\ngoto %s", $$.f);
										}
 | e '!' '=' e							{
											nueva_etq($$.v);
											nueva_etq($$.f);
											printf("\nif %s != %s goto %s", $1, $4, $$.v);
											printf("\ngoto %s", $$.f);
										}
 ;

semi: %empty
 | ';'
 ;

%%

void main(){
	printf("Compiladores II - Trabajo practico. Lenguaje: Groovy\n");
	printf("***** Inicio de traducción *****\n");
	yyparse();
	printf("\n\n***** Traduccion a tercetos finalizada *****");
}

void yyerror(char *s){
	printf("\n%s, en linea nro: %d", s, yylineno);
}