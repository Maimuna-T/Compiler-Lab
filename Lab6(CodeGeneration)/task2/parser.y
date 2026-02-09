%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

extern FILE* yyin;
int yylex();
void yyerror(char* s);

FILE *tac, *asm_f;
int t_idx = 1, line_tac = 1, line_asm = 1;
int reg_idx = 0;

char* gen_tac() {
    char* s = malloc(10);
    sprintf(s, "t%d", t_idx++);
    return s;
}

char* format_val(char* val) {
    if (val[0] >= '0' && val[0] <= '9') {
        char* buf = malloc(20);
        sprintf(buf, "#%s", val);
        return buf;
    }
    return val;
}
%}

%union { char str[50]; }

%token <str> ID NUM
%token NEWLINE SQRT POW LOG EXP SIN COS TAN ABS
%type <str> Expression Term Factor FunctionCall

%%

Program : StatementList ;

StatementList : Statement 
              | StatementList NEWLINE Statement 
              | StatementList NEWLINE ;

Statement : ID '=' Expression {
                fprintf(tac, "%d %s = %s\n", line_tac++, $1, $3);
                fprintf(asm_f, "%d MOV %s, R%d\n\n", line_asm++, $1, reg_idx > 0 ? reg_idx-1 : 0);
                reg_idx = 0; // Reset registers for next statement
            }
          ;

Expression : Expression '+' Term { 
                char* t = gen_tac(); strcpy($$, t);
                fprintf(tac, "%d %s = %s + %s\n", line_tac++, t, $1, $3);
                fprintf(asm_f, "%d ADD R0, R1\n", line_asm++);
                reg_idx = 1;
             }
           | Expression '-' Term { 
                char* t = gen_tac(); strcpy($$, t);
                fprintf(tac, "%d %s = %s - %s\n", line_tac++, t, $1, $3);
                fprintf(asm_f, "%d SUB R0, R1\n", line_asm++);
                reg_idx = 1;
             }
           | Term { strcpy($$, $1); }
           ;

Term : Term '*' Factor { 
            char* t = gen_tac(); strcpy($$, t);
            fprintf(tac, "%d %s = %s * %s\n", line_tac++, t, $1, $3);
            fprintf(asm_f, "%d MUL R0, R1\n", line_asm++);
        }
     | Term '/' Factor { 
            char* t = gen_tac(); strcpy($$, t);
            fprintf(tac, "%d %s = %s / %s\n", line_tac++, t, $1, $3);
            fprintf(asm_f, "%d DIV R0, R1\n", line_asm++);
        }
     | Factor { strcpy($$, $1); }
     ;

Factor : FunctionCall { strcpy($$, $1); }
       | '(' Expression ')' { strcpy($$, $2); }
       | ID { 
            strcpy($$, $1); 
            fprintf(asm_f, "%d MOV R%d, %s\n", line_asm++, reg_idx++, $1); 
         }
       | NUM { 
            strcpy($$, $1); 
            fprintf(asm_f, "%d MOV R%d, #%s\n", line_asm++, reg_idx++, $1); 
         }
       | '-' Factor { 
            char* t = gen_tac(); strcpy($$, t);
            fprintf(tac, "%d %s = -%s\n", line_tac++, t, $2);
            fprintf(asm_f, "%d NEG R%d\n", line_asm++, reg_idx-1);
         }
       ;

FunctionCall : SQRT '(' Expression ')' {
                char* t = gen_tac(); strcpy($$, t);
                fprintf(tac, "%d %s = sqrt(%s)\n", line_tac++, t, $3);
                fprintf(asm_f, "%d SQRT R%d\n", line_asm++, reg_idx-1);
             }
             | POW '(' Expression ',' Expression ')' {
                char* t = gen_tac(); strcpy($$, t);
                fprintf(tac, "%d %s = pow(%s, %s)\n", line_tac++, t, $3, $5);
                fprintf(asm_f, "%d POW R%d, R%d\n", line_asm++, reg_idx-2, reg_idx-1);
                reg_idx--;
             }
             | SIN '(' Expression ')' {
                char* t = gen_tac(); strcpy($$, t);
                fprintf(tac, "%d %s = sin(%s)\n", line_tac++, t, $3);
                fprintf(asm_f, "%d SIN R%d\n", line_asm++, reg_idx-1);
             }
             | COS '(' Expression ')' {
                char* t = gen_tac(); strcpy($$, t);
                fprintf(tac, "%d %s = cos(%s)\n", line_tac++, t, $3);
                fprintf(asm_f, "%d COS R%d\n", line_asm++, reg_idx-1);
             }
             | TAN '(' Expression ')' {
                char* t = gen_tac(); strcpy($$, t);
                fprintf(tac, "%d %s = tan(%s)\n", line_tac++, t, $3);
                fprintf(asm_f, "%d TAN R%d\n", line_asm++, reg_idx-1);
             }
             | LOG '(' Expression ')' {
                char* t = gen_tac(); strcpy($$, t);
                fprintf(tac, "%d %s = log(%s)\n", line_tac++, t, $3);
                fprintf(asm_f, "%d LOG R%d\n", line_asm++, reg_idx-1);
             }
             | EXP '(' Expression ')' {
                char* t = gen_tac(); strcpy($$, t);
                fprintf(tac, "%d %s = exp(%s)\n", line_tac++, t, $3);
                fprintf(asm_f, "%d EXP R%d\n", line_asm++, reg_idx-1);
             }
             | ABS '(' Expression ')' {
                char* t = gen_tac(); strcpy($$, t);
                fprintf(tac, "%d %s = abs(%s)\n", line_tac++, t, $3);
                fprintf(asm_f, "%d ABS R%d\n", line_asm++, reg_idx-1);
             }
             ;

%%

void yyerror(char* s) { printf("Error: %s\n", s); }

int main() {
    yyin = fopen("input.txt", "r");
    tac = fopen("tac.txt", "w");
    asm_f = fopen("asm.txt", "w");
    yyparse();
    fclose(tac); fclose(asm_f);
    return 0;
}