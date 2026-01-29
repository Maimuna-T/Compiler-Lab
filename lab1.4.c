#include <stdio.h>
#include <string.h>
#include <ctype.h>

int isInteger(const char str[]) {
    int i = 0;

    if (!isdigit(str[i])) return 0;
    if (str[i] == '+' || str[i] == '-'){
      i++;
    }
    for (; str[i] != '\0'; i++) {
        if (!isdigit(str[i])){
           return 0;
        }
    }
    return 1;
}

int isFloat(const char str[]) {
    int i = 0, dotCount = 0, digitCount = 0;

    if (str[i] == '+' || str[i] == '-'){
       i++;
    }

    for (; str[i] != '\0'; i++) {
        if (isdigit(str[i])){
           digitCount++;
        }
        else if (str[i] == '.') {
            dotCount++;
            if (dotCount > 1) return 0;
        } else return 0;
    }
    return (dotCount == 1 && digitCount >= 1);
}

int main() {
    FILE *fp;

    char line[500], word[50];
    int i, j;


    fp = fopen("maimuna.txt", "r");

    if (fp == NULL) {
        printf("Cannot open file.\n");
        return 1;
    }

    while (fgets(line, sizeof(line), fp) != NULL) {
        i = 0; j = 0;

        while (1) {
            if (isalnum(line[i]) || line[i] == '.' || line[i] == '+' || line[i] == '-') {
                word[j++] = line[i];
            }
            else {
                if (j > 0) {
                    word[j] = '\0';
                    if (isInteger(word))
                        printf("%s: Integer\n", word);
                    else if (isFloat(word))
                        printf("%s: Floating-point\n", word);
                    j = 0;
                }
            }

            if (line[i] == '\0') break;
            i++;
        }
    }

    fclose(fp);
    return 0;
}

