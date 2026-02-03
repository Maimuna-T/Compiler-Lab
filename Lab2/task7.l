%{
#include <stdio.h>
%}

%%


"//".*     { printf("Single-line comment\n"); }
"/*"([^*]|\*+[^*/])*(\*+"/")    { printf("Multi-line comment\n"); }
"/*"([^*]|\*+[^*/])* { printf("Lexical Error: unterminated comment\n"); }

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
