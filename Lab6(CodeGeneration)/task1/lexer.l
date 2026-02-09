%{
#include "parser.tab.h"
#include <string.h>
%}

%%
[ \t]           ;
"\n"            { return NEWLINE; }
"**="           { return POW_ASSIGN; }
"+="            { return ADD_ASSIGN; }
"-="            { return SUB_ASSIGN; }
"*="            { return MUL_ASSIGN; }
"/="            { return DIV_ASSIGN; }
"%="            { return MOD_ASSIGN; }
"//"            { return IDIV; }
"**"            { return POW; }
"&&"            { return AND; }
"||"            { return OR; }
"!"             { return '!'; }
"="             { return '='; }
"+"             { return '+'; }
"-"             { return '-'; }
"*"             { return '*'; }
"/"             { return '/'; }
"%"             { return '%'; }
"("             { return '('; }
")"             { return ')'; }
">"             { return '>'; }
"<"             { return '<'; }

[a-zA-Z][a-zA-Z0-9]* { strcpy(yylval.str, yytext); return ID; }
[0-9]+               { strcpy(yylval.str, yytext); return NUM; }

.               { return yytext[0]; }
%%

int yywrap() { return 1; }