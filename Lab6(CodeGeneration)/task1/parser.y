%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

extern FILE* yyin;
int yylex();
void yyerror(char* s);

FILE *tac, *asm_f;
int t_idx = 1, a_idx = 1, asm_line = 1;

char* gen_tac() {
    char* s = malloc(10);
    sprintf(s, "t%d", t_idx++);
    return s;
}

// Helper to format numbers as immediate values for ASM
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
%token NEWLINE POW IDIV AND OR POW_ASSIGN ADD_ASSIGN SUB_ASSIGN MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN
%type <str> Expression Term Factor Unary Primary Statement

%%

Program : StatementList ;

StatementList : Statement 
              | StatementList NEWLINE Statement 
              | StatementList NEWLINE ;

Statement : ID '=' Expression {
                fprintf(tac, "%d %s = %s\n", a_idx++, $1, $3);
                fprintf(asm_f, "%d MOV %s, R0\n\n", asm_line++, $1);
            }
          | ID ADD_ASSIGN Expression {
                fprintf(tac, "%d t%d = %s + %s\n%d %s = t%d\n", a_idx++, t_idx, $1, $3, a_idx++, $1, t_idx++);
                fprintf(asm_f, "%d MOV R1, %s\n%d ADD R1, R0\n%d MOV %s, R1\n\n", asm_line++, $1, asm_line++, asm_line++, $1);
            }
          | ID IDIV '=' Expression {
                fprintf(tac, "%d t%d = %s // %s\n%d %s = t%d\n", a_idx++, t_idx, $1, $4, a_idx++, $1, t_idx++);
                fprintf(asm_f, "%d MOV R1, %s\n%d IDIV R1, R0\n%d MOV %s, R1\n\n", asm_line++, $1, asm_line++, asm_line++, $1);
            }
          ;

Expression : Expression '+' Term { 
                char* t = gen_tac(); strcpy($$, t);
                fprintf(tac, "%d %s = %s + %s\n", a_idx++, t, $1, $3);
                fprintf(asm_f, "%d ADD R0, %s\n", asm_line++, format_val($3));
             }
           | Expression OR Term { 
                char* t = gen_tac(); strcpy($$, t);
                fprintf(tac, "%d %s = %s || %s\n", a_idx++, t, $1, $3);
                fprintf(asm_f, "%d OR R0, %s\n", asm_line++, format_val($3));
             }
           | Term { strcpy($$, $1); }
           ;

Term : Term '*' Factor { 
            char* t = gen_tac(); strcpy($$, t);
            fprintf(tac, "%d %s = %s * %s\n", a_idx++, t, $1, $3);
            fprintf(asm_f, "%d MUL R0, %s\n", asm_line++, format_val($3));
        }
     | Term IDIV Factor { 
            char* t = gen_tac(); strcpy($$, t);
            fprintf(tac, "%d %s = %s // %s\n", a_idx++, t, $1, $3);
            fprintf(asm_f, "%d IDIV R0, %s\n", asm_line++, format_val($3));
        }
     | Factor { strcpy($$, $1); }
     ;

Factor : Factor POW Unary { 
            char* t = gen_tac(); strcpy($$, t);
            fprintf(tac, "%d %s = %s ** %s\n", a_idx++, t, $1, $3);
            fprintf(asm_f, "%d POW R0, %s\n", asm_line++, format_val($3));
         }
       | Unary { strcpy($$, $1); }
       ;

Unary : '!' Unary { 
            char* t = gen_tac(); strcpy($$, t);
            fprintf(tac, "%d %s = !%s\n", a_idx++, t, $2);
            fprintf(asm_f, "%d NOT R0\n", asm_line++);
        }
      | Primary { strcpy($$, $1); }
      ;

Primary : ID { strcpy($$, $1); fprintf(asm_f, "%d MOV R0, %s\n", asm_line++, $1); }
        | NUM { strcpy($$, $1); fprintf(asm_f, "%d MOV R0, #%s\n", asm_line++, $1); }
        | '(' Expression ')' { strcpy($$, $2); }
        ;

%%

void yyerror(char* s) { printf("Syntax Error: %s\n", s); }

int main() {
    yyin = fopen("input.txt", "r");
    tac = fopen("output_tac.txt", "w");
    asm_f = fopen("output_asm.txt", "w");
    yyparse();
    fclose(tac); fclose(asm_f);
    return 0;
}