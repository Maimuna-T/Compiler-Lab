

%{
#include<stdio.h>
int char_count = 0;
int word_count = 0;
int line_count = 0;
%}

%%

\n { line_count++; char_count++; }
[ \t]+ { char_count += yyleng; }
\"[^\"]*\" { word_count++; char_count += yyleng; } 
[^ \t\n]+ { word_count++; char_count+= yyleng; }

%%

int yywrap(){
    return 1;
}


int main()
{
    FILE *fp = fopen("input.txt", "r");
    if (!fp)
    {
        printf("Error: Cannot open input.txt\n");
        return 1;
    }

    yyin = fp;
    yylex();

    printf("Characters: %d\n", char_count);
    printf("Words     : %d\n", word_count);
    printf("Lines     : %d\n", line_count);

    fclose(fp);
    return 0;
}
