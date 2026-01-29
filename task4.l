%{
#include <stdio.h>
%}

%%

([0-9]+\.[0-9]*([eE][+-]?[0-9]+)?)|(\.[0-9]+([eE][+-]?[0-9]+)?)|([0-9]+[eE][+-]?[0-9]+)  { printf("%s : float\n", yytext); }


[0-9]+  { printf("%s : integer\n", yytext); }


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
