#include <stdio.h>
#include <string.h>
#include <ctype.h>

char *keywords[] = {
    "auto","break","case","char","const","continue","default","do","double","else",
    "enum","extern","float","for","goto","if","int","long","register","return",
    "short","signed","sizeof","static","struct","switch","typedef","union",
    "unsigned","void","volatile","while"
};

int Keyword_func(char *word) {
    int i;

    for (i = 0; i < 32; i++) {
        if (strcmp(word, keywords[i]) == 0)
            return 1;
    }
    return 0;
}

int main() {
    FILE *fp;
    char line[300];
    char *token;

    fp = fopen("maimuna.txt", "r");
    if (fp == NULL) {
        printf("Cannot open \n");
        return 1;
    }

    while (fgets(line, sizeof(line), fp)) {
        token = strtok(line, " \t\n;(){}+-=*/<>!&|,");
        while (token != NULL) {
            if (Keyword_func(token)) {
                printf("%s: keyword\n", token);
            }
            token = strtok(NULL, " \t\n;(){}+-=*/<>!&|,");
        }
    }

    fclose(fp);
    return 0;
}
