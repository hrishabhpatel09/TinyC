%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
    
int yylex(void);
int yyerror(const char *s);

FILE *fs;

char* concat(const char* a, const char* b, const char* c) {
    char* res = malloc(strlen(a) + strlen(b) + strlen(c) + 1);
    strcpy(res, a);
    strcat(res, b);
    strcat(res, c);
    return res;
}
%}

%union {
    int ival;
    float fval;
    char* sval;
    struct {
        int ival;
        float fval;
        char* lexeme;
        char* type;
        int line;
        int col;
        bool isStmt;
    } tok;
};


%start program

%token <tok>INUM <tok>FNUM <tok>SLITERAL
%token <tok> ID
%token <sval> ID_TYPE <tok> VTYPE
%token OPAREN CPAREN OCURLY CCURLY ASSIGN FOR LESS INCREMENT
%token SEMICOLON
%token KW_RETURN


%type <ival> program
%type <sval> BODY
%type <sval> routines
%type <sval> routine
%type <sval> stmt_list
%type <sval>stmt
%type <tok> VAL

%%
program: routines {};
routines: routines routine  {} | routine {};
routine: VTYPE ID OPAREN CPAREN OCURLY BODY CCURLY {};
BODY: {}
     | stmt_list {};
stmt_list: stmt_list stmt {};
          | stmt {};
stmt:   {}
      | KW_RETURN INUM SEMICOLON {}
      | KW_RETURN SLITERAL SEMICOLON {}
      | KW_RETURN FNUM SEMICOLON {}
      | KW_RETURN ID SEMICOLON {}
      | VTYPE ID SEMICOLON {
        $$ = concat("let ",$2.lexeme,";\n");
        fprintf(fs, "let %s;\n", $2.lexeme);
      }
      | VTYPE ID ASSIGN VAL SEMICOLON {
        if(strcmp($1.type, $4.type) != 0) {
            fprintf(stderr,"Type Mismatch Error");
            exit(1);
        }
        char* type = $1.type;
        if(strcmp(type, "float") == 0) {
            fprintf(fs, "let %s = %f;\n", $2.lexeme, $4.fval);
        }
        else if(strcmp(type, "string") == 0) {
            fprintf(fs, "let %s = \"%s\";\n", $2.lexeme, $4.lexeme);
        }
        else fprintf(fs, "let %s = %i;\n", $2.lexeme, $4.ival);
      }
      | FOR OPAREN VTYPE ID ASSIGN VAL SEMICOLON ID LESS VAL SEMICOLON ID INCREMENT CPAREN OCURLY stmt CCURLY {
        printf("Generated for loop\n");
        fprintf(fs, "for (let %s = %s; %s < %s; %s++) {\n%s}\n", $4.lexeme, $6.lexeme, $8.lexeme, $10.lexeme, $12.lexeme, $16);
      };
      

VAL: INUM { $$ = $1; }
    | FNUM { $$ = $1; }
    | SLITERAL { $$ = $1; }
    | ID { $$ = $1; };

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