%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "task2.tab.h"

extern int yylineno;
%}

%option noyywrap
%option yylineno

%%

[ \t\r]+            { /* skip whitespace */ }
\n                  { return NEWLINE; }

"sqrt"              { return SQRT; }
"pow"               { return POW; }
"log"               { return LOG; }
"exp"               { return EXP; }
"sin"               { return SIN; }
"cos"               { return COS; }
"tan"               { return TAN; }
"abs"               { return ABS; }

[a-zA-Z_][a-zA-Z0-9_]*  { 
                        yylval.str = strdup(yytext); 
                        return ID; 
                    }

[0-9]+              { 
                        yylval.str = strdup(yytext); 
                        return NUM; 
                    }

"+"                 { return PLUS; }
"-"                 { return MINUS; }
"*"                 { return MULTIPLY; }
"/"                 { return DIVIDE; }
"%"                 { return MODULO; }
"("                 { return LPAREN; }
")"                 { return RPAREN; }
"="                 { return ASSIGN; }
","                 { return COMMA; }

.                   { printf("Unexpected character: %s\n", yytext); }

%%
