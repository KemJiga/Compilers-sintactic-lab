%{
#include <stdbool.h>
#include <stdio.h>
#include "y.tab.h"
int yylex();
void yyerror (char *s);

%}

%option yylineno

%%

"CREATE"                                       return CREATE;
"DROP"                                         return DROP;
"Table"|"TABLE"|"table"                        return TABLE;
"SELECT"                                       return SELECT;
"WHERE"                                        return WHERE;
"GROUP BY"                                     return GROUPBY;
"ORDER BY"                                     return ORDERBY;
"INSERT"                                       return INSERT;
"DELETE"                                       return DELETE;
"UPDATE"                                       return UPDATE;
"MAX"                                          return MAX;
"MIN"                                          return MIN;
"AVG"                                          return AVG;
"COUNT"                                        return COUNT;
"INTO"                                         return INTO;
"VALUES"                                       return VALUES;
"FROM"                                         return FROM;
"SET"                                          return SET;
"ASC"                                          return ASC;
"DESC"                                         return DESC;
"INTEGER"                                      return INTEGER;
"DECIMAL"                                      return DECIMAL;
"VARCHAR"                                      return VARCHAR;
"AND"                                          return AND;
"OR"                                           return OR;
[a-zA-Z][_a-zA-Z0-9]*                          return ID;
[0-9]+                                         return ENTERO;
[0-9]+"."[0-9]+                                return DECIMALNUM;
"+"                                            return MAS;
"-"                                            return MENOS;
"*"                                            return MULT;
"/"                                            return DIV;
"=="                                           return IGUALDAD;
"<>"                                           return DIFF;
">"                                            return MAYORQ;
"<"                                            return MENORQ;
">="                                           return MAYORIGUAL;
"<="                                           return MENORIGUAL;
"("                                            return PARABRE;
")"                                            return PARCIERR;
","                                            return COMA;
";"                                            return PUNTCOMA;
"="                                            return ASIG;
" * "                                          return AST;
(\"[^"]*\")|(\'[^']*\')                        return CADENA;
\n                                             ;
[ \t]                                          ;
.                                              return LEXERR;

%%

int yywrap(void){
    return 1;
}