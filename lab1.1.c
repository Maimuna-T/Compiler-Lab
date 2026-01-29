#include <stdio.h>
#include <ctype.h>

int main() {
    FILE *fp;
    char maimuna[100], ch;
    int characters = 0;
    int words = 0;
    int lines = 0;
    int inWord = 0;
    int space =0;


    fp = fopen("maimuna.txt", "r");
    if (fp == NULL) {
        printf("File can not be opened!\n");
        return 1;
    }

    while ((ch = fgetc(fp)) != EOF) {
        characters++;

        if (ch == '\n'){
            lines++;
        }
        if (ch == ' '){
            space++;
        }

        if (isspace(ch)) {
            inWord = 0;
        }
        else if (inWord == 0) {
            inWord = 1;
            words++;
        }
    }

    fclose(fp);

    printf("Characters: %d\n", characters);
    printf("Words: %d\n", words);
    printf("Lines: %d\n", lines);
    printf("Space: %d\n", space);

    return 0;
}

