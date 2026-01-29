%{
#include <stdio.h>
%}

%%

"{"      { printf("%s : special symbol\n", yytext); }
"}"      { printf("%s : special symbol\n", yytext); }
"("      { printf("%s : special symbol\n", yytext); }
")"      { printf("%s : special symbol\n", yytext); }
";"      { printf("%s : special symbol\n", yytext); }
","      { printf("%s : special symbol\n", yytext); }
"["      { printf("%s : special symbol\n", yytext); }
"]"      { printf("%s : special symbol\n", yytext); }
"."      { printf("%s : special symbol\n", yytext); }

[ \t\n]+   ;  
.          ;  

%%

int main() {
    FILE *fp = fopen("input.txt", "r");
    if (!fp) {
        printf("Error: Cannot open input.txt\n");
        return 1;
    }

    yyin = fp;
    yylex();
    fclose(fp);
    return 0;
}

int yywrap() {
    return 1;
}
