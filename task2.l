%{
#include <stdio.h>
%}

%%
int([^a-zA-Z0-9_]|$)       { printf("int : keyword\n"); }
return([^a-zA-Z0-9_]|$)    { printf("return : keyword\n"); }
if([^a-zA-Z0-9_]|$)        { printf("if : keyword\n"); }
for([^a-zA-Z0-9_]|$)       { printf("for : keyword\n"); }
while([^a-zA-Z0-9_]|$)     { printf("while : keyword\n"); }
float([^a-zA-Z0-9_]|$)     { printf("float : keyword\n"); }
char([^a-zA-Z0-9_]|$)      { printf("char : keyword\n"); }
double([^a-zA-Z0-9_]|$)    { printf("double : keyword\n"); }
void([^a-zA-Z0-9_]|$)      { printf("void : keyword\n"); }
long([^a-zA-Z0-9_]|$)      { printf("long : keyword\n"); }
short([^a-zA-Z0-9_]|$)     { printf("short : keyword\n"); }
unsigned([^a-zA-Z0-9_]|$)  { printf("unsigned : keyword\n"); }
signed([^a-zA-Z0-9_]|$)    { printf("signed : keyword\n"); }

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
