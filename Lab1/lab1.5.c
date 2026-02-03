#include <stdio.h>

int main() {
    FILE *fp;
    char ch, next;

    fp = fopen("maimuna.txt", "r");
    if (fp == NULL) {
        printf("Cannot open file.\n");
        return 1;
    }

    while ((ch = fgetc(fp)) != EOF) {
        if (ch == '/') {
            next = fgetc(fp);

            if (next == '/') {

                while ((ch = fgetc(fp)) != '\n' && ch != EOF);
                continue;
            }
            else if (next == '*') {
                int closed = 0;
                while ((ch = fgetc(fp)) != EOF) {
                    if (ch == '*') {
                        next = fgetc(fp);
                        if (next == '/') {

                            closed = 1;
                            break;
                        } else {
                            ungetc(next, fp);
                        }
                    }
                }

                if (!closed) {
                    printf("Error\n");
                }
                continue;
            }
            else {
                printf("/ : Arithmetic operator\n");
                ungetc(next, fp);
                continue;
            }
        }

        else if (ch == '>') {
            next = fgetc(fp);
            if (next == '=') printf(">= : Relational operator\n");
            else {
                printf("> : Relational operator\n");
                ungetc(next, fp);
            }
        }

        else if (ch == '<') {
            next = fgetc(fp);
            if (next == '=') printf("<= : Relational operator\n");
            else {
                printf("< : Relational operator\n");
                ungetc(next, fp);
            }
        }

        else if (ch == '!') {
            next = fgetc(fp);
            if (next == '=') printf("!= : Relational operator\n");
            else {
                printf("! : Logical NOT operator\n");
                ungetc(next, fp);
            }
        }

        else if (ch == '&') {
            next = fgetc(fp);
            if (next == '&') printf("&& : Logical operator\n");
            else ungetc(next, fp);
        }

        else if (ch == '|') {
            next = fgetc(fp);
            if (next == '|') printf("|| : Logical operator\n");
            else ungetc(next, fp);
        }

        else if (ch == '=') {
            next = fgetc(fp);
            if (next == '=') printf("== : Relational operator\n");
            else {
                printf("= : Assignment operator\n");
                ungetc(next, fp);
            }
        }

        else if (ch == '+' || ch == '-' || ch == '*') {
            printf("%c : Arithmetic operator\n", ch);
        }
    }

    fclose(fp);
    return 0;
}
