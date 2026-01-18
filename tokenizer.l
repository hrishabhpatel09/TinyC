%{
    #include<stdio.h>
    #include "./parse.tab.h"
    #include <stdlib.h>
    #include <string.h>

    char* getType(const char* str) {
        if (strcmp(str, "int") == 0)
            return "int";
        else if (strcmp(str, "float") == 0)
            return "float";
        else if (strcmp(str, "double") == 0)
            return "double";
        else
            return "-1";
    }
%}

DIGIT [0-9]
ID [a-zA-Z][A-Za-z0-9]*

%%
{DIGIT}+ { int x = atoi(strdup(yytext));
           yylval.tok.ival = x;
           yylval.tok.type = "int";
           printf("INUM: %s\n",yytext);  return INUM;}
{DIGIT}+"."{DIGIT}+ { yylval.tok.fval = atof(strdup(yytext));
           yylval.tok.type = "float";
           printf("FNUM: %s\n",yytext);  return FNUM;}

"int"|"float"|"double" {
        char* cpy = strdup(yytext);
        yylval.tok.lexeme = cpy;
        yylval.tok.type = getType(cpy);
        printf("VTYPE: %s\n",yytext); 
        return VTYPE;
    }
"return" {yylval.sval = strdup(yytext); printf("KW_RETURN: %s\n",yytext);return KW_RETURN;}
"for" {printf("FOR: %s\n",yytext);return FOR;}
{ID} {yylval.tok.lexeme = strdup(yytext); yylval.tok.type = "identifier" ;printf("ID: %s\n",yytext);return ID;}
"(" {printf("OPAREN: %s\n",yytext);return OPAREN;}
")" {printf("CPAREN: %s\n",yytext);return CPAREN;}
"{" {printf("OCURLY: %s\n",yytext);return OCURLY;}
"}" {printf("CCURLY: %s\n",yytext);return CCURLY;}
";" {printf("SEMICOLON: %s\n",yytext);return SEMICOLON;}
"=" {printf("ASSIGN: %s\n",yytext);return ASSIGN;}
"++" {printf("INCREMENT: %s\n",yytext);return INCREMENT;}
"<" {printf("LESS: %s\n",yytext);return LESS;}
\"[^\"\n]*\"  {printf("SLITERAL: %s\n",yytext);return SLITERAL;}
[" "\n] {}
%%

int yywrap(){
    return 1;
}



