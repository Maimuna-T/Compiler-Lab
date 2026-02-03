#include <stdio.h>
#include <ctype.h>
#include <string.h>


char *keywords[] = {
    "int", "float", "char", "double", "return", "if", "else", "for", "while", "do", "break", "continue","main","scanf","printf"
};
int keywordCount = 15;

int keyword_func(char *str) {
    int i;
    for (i = 0; i < keywordCount; i++) {
        if (strcmp(str, keywords[i]) == 0)
            return 1;
    }
    return 0;
}

int validIdentifier_func(char str[]) {
    int len = strlen(str);
    int i;

    if (len == 0) return 0;

    if (!isalpha((unsigned char)str[0]) && str[0] != '_')
        return 0;

    for (i = 1; i < len; i++) {
        if (!isalnum((unsigned char)str[i]) && str[i] != '_')
            return 0;
    }

    return 1;
}

int main() {
    FILE *fp = fopen("maimuna.txt", "r");
    if (!fp) {
        printf("Could not open file\n");
        return 1;
    }

    char line[500];
    int lineNo = 1;

    while (fgets(line, sizeof(line), fp)) {
        int i, idx = 0;
        char token[200];

        for (i = 0; ; i++) {
            char ch = line[i];
            if (isalnum((unsigned char)ch) || ch == '_') {
                token[idx++] = ch;
            } else {

                if (idx > 0) {
                    token[idx] = '\0';
                    if (!keyword_func(token)) {
                        if (validIdentifier_func(token))
                            printf("  %s : Valid Identifier\n", token);
                        else
                            printf("  %s : Invalid Identifier\n", token);
                    }
                    idx = 0;
                }

                if (ch == '\0' || ch == '\n') break;
            }
        }
        lineNo++;
    }
    fclose(fp);
    return 0;
}
