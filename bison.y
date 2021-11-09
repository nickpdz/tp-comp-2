%define parse.error verbose
%{
	#include<stdio.h>
	void yyerror();
	int yylex(void);
	int cantAsig=0;
	int cantVal=0;
	extern int yylineno;
%}

/*
	Comandos:
	flex flex.l
	bison -o y.tab.c -d bison.y
	gcc -o bison lex.yy.c y.tab.c
	bison.exe < sentencias.txt
	
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
	T-> boolean | short	| int | long | float | double | char | String | def | var
	DV-> num | numr | id | cad | true | false
	E-> DV + DV | DV - DV | DV / DV | DV * DV | DV % DV | DV ** DV 
	C-> DV > DV | DV < DV | DV >= DV | DV <= DV | DV == DV | DV === DV | DV != DV 
	SEMI-> ; | ε
*/


%token BOOLEAN SHORT INT LONG FLOAT DOUBLE CHAR STRING DEF VAR IF ELSE WHILE DO FOR PRINTLN READ TRUE FALSE NUM NUMR CAD ID

%left '+' '-'
%left '*' '/'

%%

p: s {cantVal++;} p
 | s													{cantVal++;}
 | error                       
 ;

s: d semi
 | a semi
 | io semi
 | if
 | for 
 | while
 | do
 | error                            
 ;

d: t ID																{printf("\nSent: Declaracion simple");}
 | t ID '=' dv												{printf("\nSent: Declaracion con asignacion");}
 | t ID '=' e													{printf("\nSent: Declaracion con asignacion aritmetica");}
 | t ID '=' c													{printf("\nSent: Declaracion con asignacion logica");}
 ;

a: ID '=' dv													{printf("\nSent: Asignacion de datos");}
 | ID '=' e 													{printf("\nSent: Asignacion Aritmetica");}
 | ID '=' c 													{printf("\nSent: Asignacion Logica");}
 | error 
 ;

io: PRINTLN dv 												{printf("\nSent: de Impresion");} 
 | PRINTLN e 													{printf("\nSent: de Impresion");}
 | READ CAD 													{printf("\nSent: de Scaneo CON impresion de mensaje");}
 | READ '(' ')'												{printf("\nSent: de Scaneo SIN impresion de mensaje");}
 | error 
 ;

if: IF '(' c ')' '{' p else						{/* el mensaje de decie en la regla ELSE */} 
 | error 
;

else: '}' ELSE '{' p '}'							{printf("\nSent: IF - ELSE(compuesta)");}
 | '}'																{printf("\nSent: IF(simple)");}
 | error
 ;

for:FOR'('d';'c';'ID'+''+'')''{'p'}'	{printf("\nSent: FOR");}
 | FOR'('d';'c';'ID'-''-'')''{'p'}'		{printf("\nSent: FOR");}
 | error 
 ;

while: WHILE '(' c ')' '{' p '}'			{printf("\nSent: WHILE");}
 | error
 ;

do: DO '{' p '}' WHILE '(' c ')'			{printf("\nSent: DO");}
 | error
;

t: BOOLEAN														{/*printf("\nTipo de dato BOOLEAN");*/}
 | SHORT															{/*printf("\nTipo de dato SHORT");*/}
 | INT																{/*printf("\nTipo de dato INT");*/}
 | LONG																{/*printf("\nTipo de dato LONG");*/}
 | FLOAT															{/*printf("\nTipo de dato FLOAT");*/}
 | DOUBLE															{/*printf("\nTipo de dato DOUBLE");*/}
 | CHAR																{/*printf("\nTipo de dato CHAR");*/}
 | STRING															{/*printf("\nTipo de dato STRING");*/}
 | DEF																{/*printf("\nTipo de dato automatico con DEF");*/}
 | VAR																{/*printf("\nTipo de dato automatico con VAR");*/}
 | error 
 ;

dv: NUM																{/*printf("\nNUM");*/}
 | NUMR																{/*printf("\nNUMR");*/}
 | ID																	{/*printf("\nID");*/}
 | CAD																{/*printf("\nCAD");*/}
 | TRUE																{/*printf("\nTRUE");*/}
 | FALSE															{/*printf("\nFALSE");*/}
 | error                       
 ;

e: dv '+' dv													{/*printf("\nExp: Suma");*/}
 | dv '-' dv													{/*printf("\nExp: Resta");*/}
 | dv '/' dv													{/*printf("\nExp: Division");*/}
 | dv '*' dv													{/*printf("\nExp: Multiplicacion");*/}
 | dv '%' dv													{/*printf("\nExp: Modulo o resto");*/}
 | dv '*' '*' dv											{/*printf("\nExp: Potencia");*/}
 | error 
 ;

c: dv '>' dv													{printf("\nCond: Mayor Que");}
 | dv '<' dv													{printf("\nCond: Menor Que");}
 | dv '>' '=' dv											{printf("\nCond: Mayor o Igual Que");}
 | dv '<' '=' dv											{printf("\nCond: Menor o Igual Que");}
 | dv '=' '=' dv											{printf("\nCond: Igual");}
 | dv '=' '=' '=' dv									{printf("\nCond: Identico");}
 | dv '!' '=' dv											{printf("\nCond: Distinto");}
 | error        
 ;

semi: %empty 													{printf("\nSin ; final");}
 | ';' 																{printf("\nCon ; final");}
 ;

%%

void main(){
	printf("Compiladores I - Trabajo practico\n");
	printf("Lenguaje: Groovy\n");
	yyparse();
	printf("\n\n\tFin del analisis de las sentencias.");
	printf("\nCantidad de sentencias validas: %d", cantVal);
}

void yyerror(char *s){
	printf("\n%s, en linea nro: %d", s, yylineno);
}