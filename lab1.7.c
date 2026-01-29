#include <stdio.h>

int main() {
    FILE *fp;
    char ch, next;

    fp = fopen("maimuna.txt", "r");
    if (fp == NULL) {
        printf("Cannot open \n");
        return 1;
    }

    while ((ch = fgetc(fp)) != EOF) {
        if (ch == '/') {
            next = fgetc(fp);

            if (next == '/') {
                printf("Single-line comment\n");
            }
            else if (next == '*') {
                printf("Multi-line comment\n");

            }
            else {
                ungetc(next, fp);
            }
        }
    }

    fclose(fp);
    return 0;
}
