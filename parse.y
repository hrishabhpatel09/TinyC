%{
#include <stdio.h>
#include <stdlib.h>

int yylex(void);
int yyerror(const char *s);
FILE *fs;
%}

%union {
    int ival;
    char* sval;
    struct {
        char* lexeme;
        int   line;
        int   col;
    } tok;
};


%start program
%token <ival> TOKEN_DIGIT 
%token <sval> TOKEN_ID
%token <sval> ID_TYPE
%token TOKEN_OPAREN TOKEN_CPAREN TOKEN_OCURLY TOKEN_CCURLY TOKEN_SLITERAL
%token <sval> TOKEN_STRING
%type <ival> program

%type <sval> BODY
%type <sval> stmt_list
%type <sval> stmt
%token <sval> KW_RETURN
%token <sval>  TOKEN_SEMICOLON

%%
program: ID_TYPE TOKEN_ID TOKEN_OPAREN TOKEN_CPAREN TOKEN_OCURLY BODY TOKEN_CCURLY
    {
        printf("Parsed a program with name: %s\n", $2);
    };

BODY: stmt_list {printf("Parsed body with %d statements\n", $1);};

stmt_list: /* empty */ { $$ = 0; }
         | stmt_list stmt { $$ = $1 + 1; }
         ;

stmt: ID_TYPE TOKEN_ID TOKEN_SEMICOLON 
    {
        fprintf(fs,"let %s;\n", $2);
        printf("Parsed statement: %s %s;\n", $1, $2);
    }
    | KW_RETURN TOKEN_DIGIT TOKEN_SEMICOLON 
    {
        printf("Parsed return statement: return %d;\n", $2);
    }
    ;

%%

int yyerror(const char *s) {
    printf("Error: %s\n", s);
    return 0;
}


int main(){
    fs = fopen("output.js", "w");
    yyparse();
    fclose(fs);
    return 0;
}