#include<stdlib.h>
#include<string.h>
/*Tabla de Símbolos - Simple*/

/*Prototipos de funciones para manejo de la tds*/

/*
   Función que busca un identificador en la tds
   recibe como parámetro el nombre del id,
   si lo encuentra retorna el tipo del mismo,
   en caso contrario retorna 0
 */
int busca(char *);

/*
   Función que agrega un nuevo identificador a la tds
   recibe como parámetros el tipo de dato y el nombre del id
 */
void agrega(int, char *);

/*
   Función para asignación de identificadores según el tipo
   de dato
 */
void cargavalor(int, char *);

/*
   Función que retorna el valor entero de un identificador
 */
int buscavalore(char *);

/*
   Función que retorna el valor real de un identificador
 */
float buscavalorr(char *);

/*
   Función que retorna el valor cadena de un identificador
 */
char * buscavalorc(char *);


/*Prototipos para funciones de tercetos*/

void nueva_tmp(char *);  //genera temporales (tercetos)
void nueva_etq(char *);  //genera etiquetas (tercetos)

/*Variables globales para intérprete*/

int retornotipo;
int valoren;
float valorre;
char valorcad[40];

/*Estructura de la TDS*/

typedef struct tds{
	char nombre[20];
	int tipo, valore;
	float valorr;
	char valorcd[40];
	struct tds * sig;
} TDS;

TDS *nuevo;
TDS *primero=NULL;
TDS *ultimo=NULL;

/*Desarrollo de las Funciones*/

int busca(char *id){
	TDS* auxi;
	auxi=primero;
	retornotipo=0;
	while(auxi!=NULL){
		if(strcmp(auxi->nombre,id)==0){
			retornotipo=auxi->tipo;
			break;
		}
		auxi=auxi->sig;
	}
	return retornotipo;
}

void agrega(int codi, char *id){
	if(busca(id)==0){
		nuevo=(TDS*)malloc(sizeof(TDS));
		strcpy(nuevo->nombre,id);
		nuevo->sig=NULL;
		nuevo->tipo=codi;
		nuevo->valore=0;
		nuevo->valorr=0.0;
		strcpy(nuevo->valorcd,"");
			if(primero==NULL){
				primero=nuevo;
				ultimo=nuevo;
			}
			else{
				ultimo->sig=nuevo;
				ultimo=nuevo;
			}
	}
}

void cargavalor(int tipo, char *id){
	TDS* auxi;
	auxi=primero;
	while(auxi!=NULL){
		if(strcmp(auxi->nombre,id)==0){
			switch(tipo){
				case 1: auxi->valore=valoren; break;
				case 2: auxi->valorr=valorre; break;
				case 3: strcpy(auxi->valorcd,valorcad); break;
			}
		}
	auxi=auxi->sig;
	}
}

int buscavalore(char *id){
	TDS* auxi;
	auxi=primero;
	while(auxi!=NULL){
		if(strcmp(auxi->nombre,id)==0){
			return auxi->valore;
			break;
		}
	auxi=auxi->sig;
	}
}

float buscavalorr(char *id){
	TDS* auxi;
	auxi=primero;
	while(auxi!=NULL){
		if(strcmp(auxi->nombre,id)==0){
			return auxi->valorr;
			break;
		}
	auxi=auxi->sig;
	}
}

char * buscavalorc(char *id){
	TDS* auxi;
	auxi=primero;
	while(auxi!=NULL){
		if(strcmp(auxi->nombre,id)==0){
			return auxi->valorcd;
			break;
		}
	auxi=auxi->sig;
	}
}

/*Funciones para tercetos*/

void nueva_tmp(char *s){
	static int actual1=0;
	strcpy(s,(char *)&"tmp");
	itoa(++actual1,&(s[3]),10);
}

void nueva_etq(char *s){
	static int actual2=0;
	strcpy(s,(char *)&"etq");
	itoa(++actual2,&(s[3]),10);
}
