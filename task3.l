%{
#include <stdio.h>
%}

%%

[a-zA-Z_][a-zA-Z0-9_]*  { printf("%s : valid identifier\n", yytext); }
[0-9][a-zA-Z0-9_]*   { printf("%s : invalid identifier\n", yytext); }
[ \t\n]+  ;  
.         ;  

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
