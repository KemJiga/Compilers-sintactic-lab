%{
    #include <stdio.h>
    #include <string.h>

    int yylex();
    extern int yylineno;
    void yyerror (char *s);
    void showError (char *s);
    int integrity = 1;
%}

%token END_OF_FILE LEXERR CREATE DROP TABLE SELECT WHERE GROUPBY ORDERBY INSERT DELETE UPDATE MAX MIN AVG COUNT INTO VALUES FROM SET ASC DESC INTEGER DECIMAL VARCHAR AND OR ID ENTERO DECIMALNUM MAS MENOS MULT DIV IGUALDAD DIFF MAYORQ MENORQ MAYORIGUAL MENORIGUAL PARABRE PARCIERR COMA PUNTCOMA ASIG AST CADENA
%start exps 
%define parse.error verbose

%%

exps    : exps exp
        | exp
        ;

exp     : create_table      
        | delete_table      
        | insert            
        | delete            
        | update            
        | basic_search      
        | function_search   
        | combine_search    
        | conditional_search 
        | group_search      
        | order_search      
        | full_search       
        | error PUNTCOMA    {showError("Error en linea");}
        ;

create_table        : CREATE TABLE ID PARABRE create_params PARCIERR PUNTCOMA ;

delete_table        : DROP TABLE ID PUNTCOMA ;

insert              : INSERT INTO mult_ids_par VALUES PARABRE insert_params PARCIERR PUNTCOMA ;

delete              : DELETE FROM ID WHERE comparations PUNTCOMA ;

update              : UPDATE ID SET ID ASIG id_num_float WHERE comparations PUNTCOMA ;

basic_search        : SELECT ast_id FROM ID PUNTCOMA ;

function_search     : SELECT funct_id FROM ID PUNTCOMA ;

combine_search      : SELECT funct_id FROM ID full PUNTCOMA ;
                    
conditional_search  : SELECT ast_id FROM ID WHERE comparations PUNTCOMA ;

group_search        : SELECT ast_id FROM ID GROUPBY ID PUNTCOMA ;

order_search        : SELECT ast_id FROM ID ORDERBY mult_ids org PUNTCOMA ;

full_search         : SELECT ast_id FROM ID full PUNTCOMA ;

create_params       : create_params COMA create_params
                    | ID data_type PARABRE ENTERO PARCIERR
                    | ID INTEGER
                    ;

full            : case_a case_b case_c
                ;

case_a          : WHERE comparations
                | /* NULL */
                ;

case_b          : GROUPBY ID
                | /* NULL */
                ;

case_c          : ORDERBY mult_ids org
                | /* NULL */
                ;

ast_id          : AST
                | mult_ids
                ;

mult_ids        : mult_ids COMA mult_ids
                | ID
                ;

mult_ids_par    : ID PARABRE mult_ids PARCIERR
                | ID
                ;

insert_params   : insert_params COMA insert_params
                | ENTERO
                | DECIMALNUM
                | CADENA
                ;

id_num_float    : ID
                | ENTERO
                | DECIMALNUM
                | CADENA
                ;

funct_id        : funct_id COMA funct_id
                | funct
                | ID
                ;

org             : ASC
                | DESC
                ;

funct           : MAX PARABRE ID PARCIERR
                | MIN PARABRE ID PARCIERR
                | AVG PARABRE ID PARCIERR
                | COUNT PARABRE ID PARCIERR
                ;

comparations    : comparations AND comparations
                | comparations OR comparations
                | condition
                ;

condition       : ID IGUALDAD values_type
                | ID MAYORQ values_type
                | ID MENORQ values_type
                | ID MAYORIGUAL values_type
                | ID MENORIGUAL values_type
                ;

values_type     : ENTERO
                | DECIMALNUM
                | CADENA
                ;

data_type       : INTEGER
                | DECIMAL
                | VARCHAR
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