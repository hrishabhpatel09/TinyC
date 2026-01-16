%{
    #include<stdio.h>
    #include "./parse.tab.h"
    #include <stdlib.h>
    #include <string.h>
%}

DIGIT [0-9]
ID [a-zA-Z][A-Za-z0-9]*

%%
{DIGIT}+ {yylval.ival = atoi(strdup(yytext)); return TOKEN_DIGIT;}

"int"|"float"|"double" {yylval.sval = strdup(yytext); return ID_TYPE;}
"return" {yylval.sval = strdup(yytext);return KW_RETURN;}
{ID} {yylval.sval = strdup(yytext);return TOKEN_ID;}
"(" {return TOKEN_OPAREN;}
")" {return TOKEN_CPAREN;}
"{" {return TOKEN_OCURLY;}
"}" {return TOKEN_CCURLY;}
";" {return TOKEN_SEMICOLON;}
\"[^\"\n]*\"  {return TOKEN_SLITERAL;}
[" "\n] {}
%%

int yywrap(){
    return 1;
}

// int yylex(void);

