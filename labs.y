%{
    #include <stdio.h>
    #include <string.h>
    int yylex(), check_lexical_error();
    int errors = 0;
    void yyerror (char *s);
    typedef struct yy_buffer_state * YY_BUFFER_STATE;
    extern FILE *yyout;
    extern int lex_error, lex_writer;
    extern YY_BUFFER_STATE yy_scan_string(char * str);
    extern void yy_delete_buffer(YY_BUFFER_STATE buffer);
    int errorCounter = 0;
%}

%union {char * s;}
%token <s> CREATE DROP TABLE SELECT WHERE GROUPBY ORDERBY INSERT DELETE UPDATE MAX MIN AVG COUNT INTO VALUES FROM SET ASC DESC INTEGER DECIMAL VARCHAR AND OR ID ENTERO DECIMALNUM MAS MENOS MULT DIV IGUALDAD DIFF MAYORQ MENORQ MAYORIGUAL MENORIGUAL PARABRE PARCIERR COMA PUNTCOMA ASIG AST CADENA
%type <s> exp error mult_ids full case_a case_b case_c ast_id id_num_float funct_id comparations full_search create_params insert_params data_type condition funct org create_table delete_table insert delete update basic_search function_search combine_search conditional_search group_search order_search
%start exp

%%

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
        | exp create_table
        | exp delete_table
        | exp insert
        | exp delete
        | exp update
        | exp basic_search
        | exp function_search
        | exp combine_search
        | exp conditional_search
        | exp group_search
        | exp order_search
        | exp full_search
        | error
        ;

create_table        : CREATE TABLE ID PARABRE create_params PARCIERR PUNTCOMA

delete_table        : DROP TABLE ID PUNTCOMA

insert              : INSERT INTO mult_ids VALUES PARABRE insert_params PARCIERR PUNTCOMA

delete              : DELETE FROM ID WHERE comparations PUNTCOMA

update              : UPDATE ID SET ID ASIG id_num_float WHERE comparations PUNTCOMA

basic_search        : SELECT ast_id FROM ID PUNTCOMA

function_search     : SELECT funct FROM ID PUNTCOMA

combine_search      : SELECT funct_id FROM ID PUNTCOMA
                    
conditional_search  : SELECT ast_id FROM ID WHERE comparations PUNTCOMA

group_search        : SELECT ast_id FROM ID GROUPBY ID PUNTCOMA

order_search        : SELECT ast_id FROM ID ORDERBY mult_ids org PUNTCOMA

full_search         : SELECT ast_id FROM ID full PUNTCOMA

create_params       : create_params COMA create_params
                    | ID data_type PARABRE ENTERO PARCIERR
                    | ID data_type 

full            : case_a case_b case_c

case_a          : WHERE comparations
                | /* epsilon */

case_b          : GROUPBY ID
                | /* epsilon */

case_c          : ORDERBY mult_ids org
                | /* epsilon */

ast_id          : AST
                | mult_ids

mult_ids        : mult_ids COMA mult_ids
                | ID

insert_params   : insert_params COMA insert_params
                | ID 
                | ENTERO
                | DECIMALNUM
                | CADENA

id_num_float    : ID
                | ENTERO
                | DECIMALNUM

funct_id        : funct_id COMA funct_id
                | funct
                | ID

org             : ASC
                | DESC

funct           : MAX PARABRE ID PARCIERR
                | MIN PARABRE ID PARCIERR
                | AVG PARABRE ID PARCIERR
                | COUNT PARABRE ID PARCIERR

comparations    : comparations AND comparations
                | comparations OR comparations
                | condition

condition       : ID IGUALDAD values_type
                | ID MAYORQ values_type
                | ID MENORQ values_type
                | ID MAYORIGUAL values_type
                | ID MENORIGUAL values_type

values_type     : ENTERO
                | DECIMALNUM
                | CADENA

data_type       : INTEGER
                | DECIMAL
                | VARCHAR
%%

int main(int argc, char **argv){
    FILE *input = fopen(argv[1], "r");
    char * line = NULL;
    size_t len = 0;
    size_t read;
    int error_line = 0;
    int file_integrity = 1;
    /***yyout = fopen(argv[2], "w");***/
    while ((read = getline(&line, &len, input)) != -1) {
        error_line += 1;
        line[strcspn(line, "\n")] = 0;
        /*printf("%s\nComponentes Léxicos:\n", line);*/
        YY_BUFFER_STATE buffer = yy_scan_string(line);
        
        if(check_lexical_error()){
            lex_error = 0;
            printf("Error en linea %d\n", error_line);
            file_integrity = 0;
        }else{
            lex_writer = 0;
            errorCounter = 0;
            yy_delete_buffer(buffer);
            YY_BUFFER_STATE buffer = yy_scan_string(line);
            yyparse();
            if(errorCounter == 0){
                /*printf("Correcto\n\n");*/
            }else{
                printf("Error en linea %d\n", error_line);
                file_integrity = 0;
            };
            yy_delete_buffer(buffer);
        };
    };
    if(file_integrity == 1){
        printf("Correcto\n");
    };
    return 0;
}

int check_lexical_error(){
    lex_writer = 1;
    int token = yylex();
    while(token){
        token = yylex();
    };
    return lex_error;
}

void yyerror (char *s) {
    ++errorCounter;
} 