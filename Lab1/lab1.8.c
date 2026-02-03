#include <stdio.h>
#include <string.h>
#include <ctype.h>

int valid_String(const char *str) {
    int len = strlen(str);
    if (len < 2) return 0;
    if (str[0] != '"' || str[len-1] != '"') return 0;
    int i;
    for ( i = 1; i < len-1; i++) {
        if (str[i] == '"' && str[i-1] != '\\') return 0;
    }
    return 1;
}

int valid_Char(const char *str) {
    int len = strlen(str);
    if (len < 3) return 0;
    if (str[0] != '\'' || str[len-1] != '\'') return 0;

    if (len == 3 && str[1] != '\\') return 1;
    if (len == 4 && str[1] == '\\') return 1;
    return 0;
}

int main() {
    FILE *fp = fopen("maimuna.txt", "r");
    if (!fp) {
        printf("Cannot open file!\n");
        return 1;
    }

    char line[500];

    while (fgets(line, sizeof(line), fp)) {
        int i = 0;
        while (line[i]) {


            if (line[i] == '"') {
                int start = i;
                i++;
                int closed = 0;

                while (line[i]) {
                    if (line[i] == '"' && line[i-1] != '\\') {
                        closed = 1;
                        break;
                    }
                    i++;
                }

                int end = i;
                char literal[500];
                int len = end - start + (closed ? 1 : 0);
                strncpy(literal, line + start, len);
                literal[len] = '\0';

                if (closed) {
                    if (valid_String(literal))
                        printf("%s : valid string literal\n", literal);
                    else
                        printf("%s : invalid string literal\n", literal);
                    i++;  // move past closing quote
                } else {
                    printf("%s : unterminated string literal \n", literal);
                }
                continue;
            }

            if (line[i] == '\'') {
                int start = i;
                i++;
                int closed = 0;

                while (line[i]) {
                    if (line[i] == '\'' && line[i-1] != '\\') {
                        closed = 1;
                        break;
                    }
                    i++;
                }

                int end = i;
                char charlit[10];
                int len = end - start + (closed ? 1 : 0);
                strncpy(charlit, line + start, len);
                charlit[len] = '\0';

                if (closed) {
                    if (valid_Char(charlit))
                        printf("%s :valid character constant\n", charlit);
                    else
                        printf("%s : invalid character constant\n", charlit);
                    i++;
                } else {
                    printf("%s : unterminated character constant\n", charlit);
                }
                continue;
            }

            i++;
        }
    }

    fclose(fp);
    return 0;
}
