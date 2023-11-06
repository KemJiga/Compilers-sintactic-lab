%{
#define YYSTYPE char const *
#include <stdbool.h>
#include <stdio.h>
#include "y.tab.h"
int yylex();

bool error_flag = false;
int lex_error = 0;
int lex_writer = 1;

%}

%%
"CREATE"                                       if(lex_writer == 1){/*printf("command=CREATE ");*/}; error_flag = false; return CREATE;
"DROP"                                         if(lex_writer == 1){/*printf("command=DROP ");*/}; error_flag = false; return DROP;
"Table"|"TABLE"|"table"                        if(lex_writer == 1){/*printf("command=TABLE ");*/}; error_flag = false; return TABLE;
"SELECT"                                       if(lex_writer == 1){/*printf("command=SELECT ");*/}; error_flag = false; return SELECT;
"WHERE"                                        if(lex_writer == 1){/*printf("command=WHERE ");*/}; error_flag = false; return WHERE;
"GROUP BY"                                     if(lex_writer == 1){/*printf("command=GROUP BY ");*/}; error_flag = false; return GROUPBY;
"ORDER BY"                                     if(lex_writer == 1){/*printf("command=ORDER BY ");*/}; error_flag = false; return ORDERBY;
"INSERT"                                       if(lex_writer == 1){/*printf("command=INSERT ");*/}; error_flag = false; return INSERT;
"DELETE"                                       if(lex_writer == 1){/*printf("command=DELETE ");*/}; error_flag = false; return DELETE;
"UPDATE"                                       if(lex_writer == 1){/*printf("command=UPDATE ");*/}; error_flag = false; return UPDATE;
"MAX"                                          if(lex_writer == 1){/*printf("command=MAX ");*/}; error_flag = false; return MAX;
"MIN"                                          if(lex_writer == 1){/*printf("command=MIN ");*/}; error_flag = false; return MIN;
"AVG"                                          if(lex_writer == 1){/*printf("command=AVG ");*/}; error_flag = false; return AVG;
"COUNT"                                        if(lex_writer == 1){/*printf("command=COUNT ");*/}; error_flag = false; return COUNT;
"INTO"                                         if(lex_writer == 1){/*printf("command=INTO ");*/}; error_flag = false; return INTO;
"VALUES"                                       if(lex_writer == 1){/*printf("command=VALUES ");*/}; error_flag = false; return VALUES;
"FROM"                                         if(lex_writer == 1){/*printf("command=FROM ");*/}; error_flag = false; return FROM;
"SET"                                          if(lex_writer == 1){/*printf("command=SET ");*/}; error_flag = false; return SET;
"ASC"                                          if(lex_writer == 1){/*printf("command=ASC ");*/}; error_flag = false; return ASC;
"DESC"                                         if(lex_writer == 1){/*printf("command=DESC ");*/}; error_flag = false; return DESC;

"INTEGER"                                      if(lex_writer == 1){/*printf("type=INTEGER ");*/}; error_flag = false; return INTEGER;
"DECIMAL"                                      if(lex_writer == 1){/*printf("type=DECIMAL ");*/}; error_flag = false; return DECIMAL;
"VARCHAR"                                      if(lex_writer == 1){/*printf("type=VARCHAR ");*/}; error_flag = false; return VARCHAR;

"AND"|"and"|"And"                              if(lex_writer == 1){/*printf("op-and=AND ");*/}; error_flag = false; return AND;
"OR"|"or"|"Or"                                 if(lex_writer == 1){/*printf("op-or=OR ");*/}; error_flag = false; return OR;

[a-zA-Z][_a-zA-Z0-9]*                          if(lex_writer == 1){/*printf("id=%s ", yytext);*/}; error_flag = false; return ID;
[0-9]+                                         if(lex_writer == 1){/*printf("entero=%s ", yytext);*/}; error_flag = false; return ENTERO;
[0-9]+"."[0-9]+                                if(lex_writer == 1){/*printf("decimal=%s ", yytext);*/}; error_flag = false; return DECIMALNUM;
[0-9]+[_a-zA-Z0-9]+                            if(!error_flag){if(!lex_error){lex_error = 1;}if(lex_writer == 1){/*printf("Error lexico= %s en linea %d ", yytext, yylineno);*/}; error_flag = true;};

"+"                                            if(lex_writer == 1){/*printf("op-mas= + ");*/}; error_flag = false; return MAS;
"-"                                            if(lex_writer == 1){/*printf("op-menos= - ");*/}; error_flag = false; return MENOS;
"*"                                            if(lex_writer == 1){/*printf("op-mult= * ");*/}; error_flag = false; return MULT;
"/"                                            if(lex_writer == 1){/*printf("op-div= / ");*/}; error_flag = false; return DIV;

"=="                                           if(lex_writer == 1){/*printf("op-igualdad= == ");*/}; error_flag = false; return IGUALDAD;
"<>"                                           if(lex_writer == 1){/*printf("op-diff= <> ");*/}; error_flag = false; return DIFF;
">"                                            if(lex_writer == 1){/*printf("op-mayorq= > ");*/}; error_flag = false; return MAYORQ;
"<"                                            if(lex_writer == 1){/*printf("op-menorq= < ");*/}; error_flag = false; return MENORQ;
">="                                           if(lex_writer == 1){/*printf("op-mayorigual= >= ");*/}; error_flag = false; return MAYORIGUAL;
"<="                                           if(lex_writer == 1){/*printf("op-menorigual= <= ");*/}; error_flag = false; return MENORIGUAL;

"("                                            if(lex_writer == 1){/*printf("parabre=( ");*/}; error_flag = false; return PARABRE;
")"                                            if(lex_writer == 1){/*printf("parcierr=) ");*/}; error_flag = false; return PARCIERR;
","                                            if(lex_writer == 1){/*printf("coma=, ");*/}; error_flag = false; return COMA;
";"                                            if(lex_writer == 1){/*printf("puntcoma=;\n");*/}; error_flag = false; return PUNTCOMA;
"="                                            if(lex_writer == 1){/*printf("asig= = ");*/}; error_flag = false; return ASIG;

" * "                                          if(lex_writer == 1){/*printf("asterisco= * ");*/}; error_flag = false; return AST;

(\"[^"]*\")|(\'[^']*\')                        if(lex_writer == 1){/*printf("cadena=%s ", yytext);*/}; error_flag = false; return CADENA;

[ \t\n]                                        ;
.                                              if(!error_flag){if(!lex_error){lex_error = 1;}if(lex_writer == 1){/*printf("ERROR Léxico!!");*/}; error_flag = true;};
%%

int yywrap(void){
    return 1;
}