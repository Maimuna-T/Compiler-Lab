%{
#include <stdio.h>
#include <string.h>
#include "icg.tab.h"
%}

%%
[ \t]+          { }          /* ignore spaces */

"**="           { return POWASSIGN; }
"**"            { return POW; }
"//"            { return INTDIV; }
"+="            { return PLUSASSIGN; }
"-="            { return MINUSASSIGN; }
"*="            { return MULASSIGN; }
"/="            { return DIVASSIGN; }
"%="            { return MODASSIGN; }
"&&"            { return AND; }
"||"            { return OR; }
">"             { return GT; }
"<"             { return LT; }

[a-zA-Z][a-zA-Z0-9]*  {
                    strcpy(yylval.cvar, yytext);
                    return ID;
                }

[0-9]+          {
                    strcpy(yylval.cvar, yytext);
                    return NUM;
                }

[-+*/%!=()]     { return yytext[0]; }

\n              { return NEWLINE; }

.               {
                    printf("Invalid character: %s\n", yytext);
                }
%%

int yywrap() {
    return 1;
}
