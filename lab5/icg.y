%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

extern FILE* yyin;
int yylex(void);

int t_count = 1;

void yyerror(char *s)
{
    fprintf(stderr, "Syntax error: %s\n", s);
}

char* getTemp()
{
    char *ret = (char *)malloc(20);
    sprintf(ret, "t%d", t_count);
    t_count++;
    return ret;
}
%}

%union {
    char cvar[20];
}

%token <cvar> ID NUM
%token NEWLINE
%token PLUSASSIGN MINUSASSIGN MULASSIGN DIVASSIGN MODASSIGN POWASSIGN
%token AND OR POW INTDIV GT LT

%type <cvar> Expression Term Factor Unary Primary Statement

/* Operator precedence following the grammar */
%left OR
%left AND
%left '+' '-'
%left '*' '/' INTDIV '%'
%right POW
%right '!' UMINUS

%%
Program:
      StatementList
    ;

StatementList:
      Statement
    | StatementList NEWLINE Statement
    ;

Statement:
      ID '=' Expression {
          printf("%s = %s\n", $1, $3);
      }
    | ID PLUSASSIGN Expression {
          char *temp = getTemp();
          printf("%s = %s + %s\n", temp, $1, $3);
          printf("%s = %s\n", $1, temp);
      }
    | ID MINUSASSIGN Expression {
          char *temp = getTemp();
          printf("%s = %s - %s\n", temp, $1, $3);
          printf("%s = %s\n", $1, temp);
      }
    | ID MULASSIGN Expression {
          char *temp = getTemp();
          printf("%s = %s * %s\n", temp, $1, $3);
          printf("%s = %s\n", $1, temp);
      }
    | ID DIVASSIGN Expression {
          char *temp = getTemp();
          printf("%s = %s / %s\n", temp, $1, $3);
          printf("%s = %s\n", $1, temp);
      }
    | ID MODASSIGN Expression {
          char *temp = getTemp();
          printf("%s = %s %% %s\n", temp, $1, $3);
          printf("%s = %s\n", $1, temp);
      }
    | ID POWASSIGN Expression {
          char *temp = getTemp();
          printf("%s = %s ** %s\n", temp, $1, $3);
          printf("%s = %s\n", $1, temp);
      }
    ;

Expression:
      Expression '+' Term {
          char *temp = getTemp();
          printf("%s = %s + %s\n", temp, $1, $3);
          strcpy($$, temp);
      }
    | Expression '-' Term {
          char *temp = getTemp();
          printf("%s = %s - %s\n", temp, $1, $3);
          strcpy($$, temp);
      }
    | Expression OR Term {
          char *temp = getTemp();
          printf("%s = %s || %s\n", temp, $1, $3);
          strcpy($$, temp);
      }
    | Expression AND Term {
          char *temp = getTemp();
          printf("%s = %s && %s\n", temp, $1, $3);
          strcpy($$, temp);
      }
    | Expression GT Term {
          char *temp = getTemp();
          printf("%s = %s > %s\n", temp, $1, $3);
          strcpy($$, temp);
      }
    | Expression LT Term {
          char *temp = getTemp();
          printf("%s = %s < %s\n", temp, $1, $3);
          strcpy($$, temp);
      }
    | Term {
          strcpy($$, $1);
      }
    ;

Term:
      Term '*' Factor {
          char *temp = getTemp();
          printf("%s = %s * %s\n", temp, $1, $3);
          strcpy($$, temp);
      }
    | Term '/' Factor {
          char *temp = getTemp();
          printf("%s = %s / %s\n", temp, $1, $3);
          strcpy($$, temp);
      }
    | Term INTDIV Factor {
          char *temp = getTemp();
          printf("%s = %s // %s\n", temp, $1, $3);
          strcpy($$, temp);
      }
    | Term '%' Factor {
          char *temp = getTemp();
          printf("%s = %s %% %s\n", temp, $1, $3);
          strcpy($$, temp);
      }
    | Factor {
          strcpy($$, $1);
      }
    ;

Factor:
      Factor POW Unary {
          char *temp = getTemp();
          printf("%s = %s ** %s\n", temp, $1, $3);
          strcpy($$, temp);
      }
    | Unary {
          strcpy($$, $1);
      }
    ;

Unary:
      '!' Unary {
          char *temp = getTemp();
          printf("%s = ! %s\n", temp, $2);
          strcpy($$, temp);
      }
    | '-' Unary %prec UMINUS {
          char *temp = getTemp();
          printf("%s = - %s\n", temp, $2);
          strcpy($$, temp);
      }
    | Primary {
          strcpy($$, $1);
      }
    ;

Primary:
      ID {
          strcpy($$, $1);
      }
    | NUM {
          strcpy($$, $1);
      }
    | '(' Expression ')' {
          strcpy($$, $2);
      }
    ;

%%

int main()
{
    yyin = fopen("input.txt", "r");
    if (!yyin) {
        fprintf(stderr, "Error: Cannot open input.txt\n");
        return 1;
    }
    yyparse();
    fclose(yyin);
    return 0;
}
