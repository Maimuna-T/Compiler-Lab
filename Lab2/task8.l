%{
#include <stdio.h>
%}

%%


\"([^"\n]|\\.)*\"            { printf("%s : Valid String Literal\n", yytext); }

\"([^"\n]|\\.)*              { printf("%s : Unterminated string Literal  (Invalid)\n", yytext); }

\'([^\'\n]|\\.)\'             { printf("%s : Valid Character constant\n", yytext); }

\'\'                           { printf("'' : Empty char constant (Invalid)\n"); }

\'([^\'\n]|\\.)[^\'\n]+\'      { printf("%s : Multiple characters in constant (Invalid)\n", yytext); }

\'([^\'\n]|\\.)*             { printf("' : Unterminated char constant (Invalid)\n"); }

[ \t\n]+         ;  
.                ;  

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
