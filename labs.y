%{
    #include <stdio.h>
    #include <string.h>

    int yylex();
    extern int yylineno;
    void yyerror (char *s);
    void showError (char *s);
    int integrity = 1;
%}

%token LEXERR CREATE DROP TABLE SELECT WHERE GROUPBY ORDERBY INSERT DELETE UPDATE MAX MIN AVG COUNT INTO VALUES FROM SET ASC DESC INTEGER DECIMAL VARCHAR AND OR ID ENTERO DECIMALNUM MAS MENOS MULT DIV IGUALDAD DIFF MAYORQ MENORQ MAYORIGUAL MENORIGUAL PARABRE PARCIERR COMA PUNTCOMA ASIG AST CADENA
%start prog 
%define parse.error verbose

%%

prog    : prog exp
        | exp
        ;

exp     : create_table      
        | delete_table      
        | insert            
        | delete            
        | update      
        | basic_search
        | error PUNTCOMA    {showError("Error en linea");}
        ;

create_table        : CREATE TABLE ID PARABRE create_args PARCIERR PUNTCOMA ;

delete_table        : DROP TABLE ID PUNTCOMA ;

insert              : INSERT INTO ID insert_args VALUES PARABRE params PARCIERR PUNTCOMA ;

delete              : DELETE FROM ID WHERE mult_conditions PUNTCOMA ; 

update              : UPDATE ID SET value_asig WHERE mult_conditions PUNTCOMA ;

basic_search        : SELECT select_params FROM ID  full_search PUNTCOMA ;

full_search         : cond group order ;

cond                : WHERE mult_conditions 
                    | /* NULL */
                    ;

group               : GROUPBY ID 
                    | /* NULL */ 
                    ;

order               : ORDERBY mult_ids order_type 
                    | /* NULL */ 
                    ;

order_type          : ASC 
                    | DESC 
                    ;

select_params       : AST
                    | select_mult
                    | mult_ids
                    ;

select_mult         : select_mult COMA select_mult
                    | function
                    | ID
                    ;

function            : MAX PARABRE ID PARCIERR
                    | MIN PARABRE ID PARCIERR
                    | AVG PARABRE ID PARCIERR
                    | COUNT PARABRE ID PARCIERR
                    ;

value_asig          : ID ASIG ENTERO
                    | ID ASIG DECIMALNUM
                    | ID ASIG CADENA
                    ;

mult_conditions     : mult_conditions AND mult_conditions
                    | mult_conditions OR mult_conditions
                    | condition
                    ;

condition           : ID logic_operatos ENTERO
                    | ID logic_operatos DECIMALNUM
                    | ID logic_operatos CADENA
                    ;

logic_operatos      : IGUALDAD
                    | MAYORQ
                    | MENORQ
                    | MAYORIGUAL
                    | MENORIGUAL
                    ;

insert_args         : PARABRE mult_ids PARCIERR
                    | /* NULL */
                    ;

mult_ids            : mult_ids COMA mult_ids
                    | ID
                    ;

params              : params COMA params
                    | ENTERO
                    | DECIMALNUM
                    | CADENA
                    ;

create_args         : create_args COMA create_args
                    | ID sql_data_type PARABRE ENTERO PARCIERR
                    | ID sql_data_type
                    ;

sql_data_type       : VARCHAR
                    | INTEGER
                    | DECIMAL
                    ;
%%

int main(int argc, char **argv){
    extern FILE *yyin, *yyout;

    yyin = fopen(argv[1], "r");
    yyout = fopen(argv[3], "w");
    yyparse();

    if(integrity == 1){
        printf("Correcto\n");
    };

    return 0;
};

void showError (char *s) {
    printf("%s %d\n", s, yylineno);
}

void yyerror (char *s) {
    if(integrity == 1){
        printf("Incorrecto\n\n");
        integrity = 0;
    };
    /*printf("%s \n", s);*/
    /*printf("Error en linea %d\n", yylineno);*/
} 