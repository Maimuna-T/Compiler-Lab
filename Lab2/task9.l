%{
#include <stdio.h>
int keyword_count = 0;
int identifiers_count = 0;
int constant_count = 0;
int operators_count = 0;
int sp_symbol_count = 0;
int string_count = 0;
int invalid_count = 0;
%}

%%
int([^a-zA-Z0-9_]|$)       { printf("<int : keyword>\n"); keyword_count++;}
return([^a-zA-Z0-9_]|$)    { printf("<return : keyword>\n"); keyword_count++; }
if([^a-zA-Z0-9_]|$)        { printf("<if : keyword>\n"); keyword_count++;}
for([^a-zA-Z0-9_]|$)       { printf("<for : keyword>\n"); keyword_count++;}
while([^a-zA-Z0-9_]|$)     { printf("<while : keyword>\n"); keyword_count++;}
float([^a-zA-Z0-9_]|$)     { printf("<float : keyword>\n"); keyword_count++;}
char([^a-zA-Z0-9_]|$)      { printf("<char : keyword>\n"); keyword_count++;}
double([^a-zA-Z0-9_]|$)    { printf("<double : keyword>\n"); keyword_count++;}
void([^a-zA-Z0-9_]|$)      { printf("<void : keyword>\n"); keyword_count++;}
long([^a-zA-Z0-9_]|$)      { printf("<long : keyword>\n"); keyword_count++;}
short([^a-zA-Z0-9_]|$)     { printf("<short : keyword>\n"); keyword_count++;}
unsigned([^a-zA-Z0-9_]|$)  { printf("<unsigned : keyword>\n"); keyword_count++;}
signed([^a-zA-Z0-9_]|$)    { printf("<signed : keyword>\n"); keyword_count++;}

\"([^"\n]|\\.)*\"            { printf("<%s : String Literal>\n", yytext); string_count++;}

\"([^"\n]|\\.)*              { invalid_count++; }

\'([^\'\n]|\\.)\'             { printf("<%s : Character constant>\n", yytext); string_count++;}

\'\'                           { invalid_count++;}

\'([^\'\n]|\\.)[^\'\n]+\'      { invalid_count++; }

\'([^\'\n]|\\.)*             { invalid_count++; }

([0-9]+\.[0-9]*([eE][+-]?[0-9]+)?)|(\.[0-9]+([eE][+-]?[0-9]+)?)|([0-9]+[eE][+-]?[0-9]+)  { printf("<%s : constant>\n", yytext); constant_count++; }
[0-9]+  { printf("<%s : constant>\n", yytext); constant_count++; }

[a-zA-Z_][a-zA-Z0-9_]*  { printf("<%s : identifier>\n", yytext);identifiers_count++; }
[0-9][a-zA-Z0-9_]*   { invalid_count++; }


"&&" { printf("<%s : logical operator>\n", yytext); operators_count++; }
"||" { printf("<%s : logical operator>\n", yytext); operators_count++; }
"!"  { printf("<%s : logical operator>\n", yytext); operators_count++; }

"==" { printf("<%s : relational operator>\n", yytext); operators_count++; }
"!=" { printf("<%s : relational operator>\n", yytext); operators_count++; }
">=" { printf("<%s : relational operator>\n", yytext); operators_count++; }
"<=" { printf("<%s : relational operator>\n", yytext); operators_count++; }
">"  { printf("<%s : relational operator>\n", yytext); operators_count++; }
"<"  { printf("<%s : relational operator>\n", yytext); operators_count++; }

"="  { printf("<%s : assignment operator>\n", yytext); operators_count++; }

"+"  { printf("<%s : arithmetic operator>\n", yytext); operators_count++; }
"-"  { printf("<%s : arithmetic operator>\n", yytext); operators_count++; }
"*"  { printf("<%s : arithmetic operator>\n", yytext); operators_count++; }
"/"  { printf("<%s : arithmetic operator>\n", yytext); operators_count++; }
"%"  { printf("<%s : arithmetic operator>\n", yytext); operators_count++; }

"{" { printf("<%s : special symbol>\n", yytext); sp_symbol_count++; }
"}" { printf("<%s : special symbol>\n", yytext); sp_symbol_count++; }
"(" { printf("<%s : special symbol>\n", yytext); sp_symbol_count++; }
")" { printf("<%s : special symbol>\n", yytext); sp_symbol_count++; }
";" { printf("<%s : special symbol>\n", yytext); sp_symbol_count++; }
"," { printf("<%s : special symbol>\n", yytext); sp_symbol_count++; }
"[" { printf("<%s : special symbol>\n", yytext); sp_symbol_count++; }
"]" { printf("<%s : special symbol>\n", yytext); sp_symbol_count++; }
"." { printf("<%s : special symbol>\n", yytext); sp_symbol_count++; }





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

    printf("\n\nToken Counts :- \n");
    printf("keyword: %d\n", keyword_count);
    printf("identifiers: %d\n", identifiers_count);
    printf("constants: %d\n", constant_count);
    printf("operators: %d\n", operators_count);
    printf("special symbols: %d\n", sp_symbol_count);
    printf("string literals: %d\n", string_count);
    printf("Invalid tokens: %d\n", invalid_count);

    fclose(fp);
    return 0;
}

int yywrap() {
    return 1;
}
