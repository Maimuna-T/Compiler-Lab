%{
#include "parser.tab.h"
#include <string.h>
%}

%%
[ \t]           ; /* Skip whitespace */
"\n"            { return NEWLINE; }
"sqrt"          { return SQRT; }
"pow"           { return POW; }
"log"           { return LOG; }
"exp"           { return EXP; }
"sin"           { return SIN; }
"cos"           { return COS; }
"tan"           { return TAN; }
"abs"           { return ABS; }
","             { return ','; }
"="             { return '='; }
"+"             { return '+'; }
"-"             { return '-'; }
"*"             { return '*'; }
"/"             { return '/'; }
"%"             { return '%'; }
"("             { return '('; }
")"             { return ')'; }

[a-zA-Z][a-zA-Z0-9]* { strcpy(yylval.str, yytext); return ID; }
[0-9]+               { strcpy(yylval.str, yytext); return NUM; }
.                    { return yytext[0]; }
%%

int yywrap() { return 1; }