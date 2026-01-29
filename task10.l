%{
#include <stdio.h>
%}

%%

\"([^"\n]|\\.)*        { printf("Lexical Error: Unterminated string literal: %s\n", yytext); }
"/*"(.|\n)*$           { printf("Lexical Error: Unclosed comment\n"); }
[0-9]+[a-zA-Z_]+       { printf("Lexical Error: Invalid identifier: %s\n", yytext); }
[a-zA-Z_]+-[a-zA-Z_]+  { printf("Lexical Error: Invalid identifier: %s\n", yytext); }
"@"[a-zA-Z_]+          { printf("Lexical Error: Invalid identifier: %s\n", yytext); }
"@"|"$"|"#"            { printf("Lexical Error: Invalid character: %s\n", yytext); }

[ \t\n]+               ;
.                      ;  

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
