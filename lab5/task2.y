%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex();
void yyerror(const char *s);
extern FILE *yyin;
extern int yylineno;

int temp_count = 0;

char* new_temp() {
    char *temp = (char*)malloc(10);
    sprintf(temp, "t%d", ++temp_count);
    return temp;
}

void emit(const char *result, const char *arg1, const char *op, const char *arg2) {
    if (op == NULL) {
        printf("%s = %s\n", result, arg1);
    } else if (arg2 == NULL) {
        printf("%s = %s%s\n", result, op, arg1);
    } else {
        printf("%s = %s %s %s\n", result, arg1, op, arg2);
    }
}

void emit_func1(const char *result, const char *func, const char *arg) {
    printf("%s = %s(%s)\n", result, func, arg);
}

void emit_func2(const char *result, const char *func, const char *arg1, const char *arg2) {
    printf("%s = %s(%s, %s)\n", result, func, arg1, arg2);
}

%}

%union {
    char *str;
}

%token <str> ID NUM
%token PLUS MINUS MULTIPLY DIVIDE MODULO
%token LPAREN RPAREN ASSIGN COMMA NEWLINE
%token SQRT POW LOG EXP SIN COS TAN ABS

%type <str> Expression Term Factor FunctionCall Statement

%left PLUS MINUS
%left MULTIPLY DIVIDE MODULO
%right UMINUS

%%

Program:
    StatementList
    ;

StatementList:
    Statement
    | StatementList NEWLINE Statement
    | StatementList NEWLINE
    ;

Statement:
    ID ASSIGN Expression {
        emit($1, $3, NULL, NULL);
        free($3);
    }
    ;

Expression:
    Expression PLUS Term {
        char *temp = new_temp();
        emit(temp, $1, "+", $3);
        free($1);
        free($3);
        $$ = temp;
    }
    | Expression MINUS Term {
        char *temp = new_temp();
        emit(temp, $1, "-", $3);
        free($1);
        free($3);
        $$ = temp;
    }
    | Term {
        $$ = $1;
    }
    ;

Term:
    Term MULTIPLY Factor {
        char *temp = new_temp();
        emit(temp, $1, "*", $3);
        free($1);
        free($3);
        $$ = temp;
    }
    | Term DIVIDE Factor {
        char *temp = new_temp();
        emit(temp, $1, "/", $3);
        free($1);
        free($3);
        $$ = temp;
    }
    | Term MODULO Factor {
        char *temp = new_temp();
        emit(temp, $1, "%", $3);
        free($1);
        free($3);
        $$ = temp;
    }
    | Factor {
        $$ = $1;
    }
    ;

Factor:
    FunctionCall {
        $$ = $1;
    }
    | LPAREN Expression RPAREN {
        $$ = $2;
    }
    | ID {
        $$ = $1;
    }
    | NUM {
        $$ = $1;
    }
    | MINUS Factor %prec UMINUS {
        char *temp = new_temp();
        emit(temp, $2, "-", NULL);
        free($2);
        $$ = temp;
    }
    ;

FunctionCall:
    SQRT LPAREN Expression RPAREN {
        char *temp = new_temp();
        emit_func1(temp, "sqrt", $3);
        free($3);
        $$ = temp;
    }
    | POW LPAREN Expression COMMA Expression RPAREN {
        char *temp = new_temp();
        emit_func2(temp, "pow", $3, $5);
        free($3);
        free($5);
        $$ = temp;
    }
    | LOG LPAREN Expression RPAREN {
        char *temp = new_temp();
        emit_func1(temp, "log", $3);
        free($3);
        $$ = temp;
    }
    | EXP LPAREN Expression RPAREN {
        char *temp = new_temp();
        emit_func1(temp, "exp", $3);
        free($3);
        $$ = temp;
    }
    | SIN LPAREN Expression RPAREN {
        char *temp = new_temp();
        emit_func1(temp, "sin", $3);
        free($3);
        $$ = temp;
    }
    | COS LPAREN Expression RPAREN {
        char *temp = new_temp();
        emit_func1(temp, "cos", $3);
        free($3);
        $$ = temp;
    }
    | TAN LPAREN Expression RPAREN {
        char *temp = new_temp();
        emit_func1(temp, "tan", $3);
        free($3);
        $$ = temp;
    }
    | ABS LPAREN Expression RPAREN {
        char *temp = new_temp();
        emit_func1(temp, "abs", $3);
        free($3);
        $$ = temp;
    }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error at line %d: %s\n", yylineno, s);
}

int main(int argc, char **argv) {
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            perror("Error opening file");
            return 1;
        }
        yyin = file;
    } else {
        yyin = fopen("input.txt", "r");
        if (!yyin) {
            fprintf(stderr, "Error: Could not open input.txt\n");
            return 1;
        }
    }
    
    yyparse();
    
    if (yyin != stdin) {
        fclose(yyin);
    }
    
    return 0;
}
