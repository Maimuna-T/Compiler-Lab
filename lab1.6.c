
#include <stdio.h>

int main() {
    FILE *fp;
    char ch;

    fp = fopen("maimuna.txt", "r");
    if (fp == NULL) {
        printf("Cannot open maimuna.txt\n");
        return 1;
    }

    printf("Detected punctuation/special symbols:\n");

    while ((ch = fgetc(fp)) != EOF) {
            if (ch == '{') {
                printf("%c\n",ch);
            }

            if (ch == '}') {
                printf("%c\n",ch);
            }

            if (ch == '[') {
                printf("%c\n",ch);
            }

            if (ch == ']') {
                printf("%c\n",ch);
            }

            if (ch == '(') {
               printf("%c\n",ch);
            }

            if (ch == ')') {
                printf("%c\n",ch);
            }

            if (ch == ';') {
               printf("%c\n",ch);
            }

            if (ch == ',') {
                printf("%c\n",ch);
            }

            if (ch == '.') {
                printf("%c\n",ch);
            }
    }

    fclose(fp);
    return 0;
}

