#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#define MAX_BUF 512

int isValidIdentifier(const char *s) {
    int i;
    if (!s || !s[0]) return 0;
    if (!(isalpha((unsigned char)s[0]) || s[0]=='_')) return 0;
    for (i=1; s[i]; i++) {
        if (!(isalnum((unsigned char)s[i]) || s[i]=='_')) return 0;
    }
    return 1;
}

int delimiter(char c) {
    const char *delims = " \t\n(){}[],;+-*/%=<>!&|^~?:.\"'";
    return (strchr(delims, c) != NULL);
}

int main() {
    FILE *fp = fopen("maimuna.txt", "r");
    if (!fp) {
        printf("Cannot open file\n");
        return 1;
    }

    int c, line = 1;
    char piece[MAX_BUF];
    int i;

    while ((c = fgetc(fp)) != EOF) {
        if (c == '\n') { line++; continue; }
        if (isspace((unsigned char)c)) continue;

        if (c == '/') {
            int next = fgetc(fp);
            if (next == '/') {
                while ((c = fgetc(fp)) != EOF && c != '\n');
                if (c == '\n') line++;
                continue;
            } else if (next == '*') {
                int closed = 0;
                while ((c = fgetc(fp)) != EOF) {
                    if (c == '\n') line++;
                    if (c == '*') {
                        int n2 = fgetc(fp);
                        if (n2 == '/') { closed = 1; break; }
                        if (n2 == EOF) break;
                        ungetc(n2, fp);
                    }
                }
                if (!closed) printf("%d:Error: Unclosed comment\n", line);
                continue;
            } else {
                if (next != EOF) ungetc(next, fp);
                continue;
            }
        }


        if (c == '"') {
            int start = line;
            int idx = 0;
            piece[idx++] = c;
            int closed = 0;
            while ((c = fgetc(fp)) != EOF) {
                piece[idx++] = c;
                if (c == '\n') { line++; break; }
                if (c == '"' && piece[idx-2] != '\\') { closed = 1; break; }
                if (idx >= MAX_BUF-1) break;
            }
            piece[idx] = '\0';
            if (!closed) printf("Error: Unterminated string literal : %s\n",piece);
            continue;
        }

//character
        if (c == '\'') {
            int start = line;
            int idx = 0;
            piece[idx++] = c;

            int ch1 = fgetc(fp);
            if (ch1 == EOF || ch1 == '\n') {
                piece[idx] = '\0';
                printf("Error: Unterminated character constant : %s\n", piece);
                continue;
            }
            piece[idx++] = ch1;

            if (ch1 == '\\') {
                int ch2 = fgetc(fp);
                piece[idx++] = ch2;
            }

            int closing = fgetc(fp);
            piece[idx++] = closing;
            piece[idx] = '\0';

            if (closing != '\'') {
                printf("Error: Invalid or unterminated character constant : %s\n",  piece);
                while (closing != EOF && closing != '\n' && closing != '\'') closing = fgetc(fp);
            }
            continue;
        }

//identifiers .
        if (isalpha((unsigned char)c) || c == '_') {
            int start = line;
            int idx = 0;
            piece[idx++] = c;
            int ch;
            while ((ch = fgetc(fp)) != EOF && !delimiter(ch)) piece[idx++] = ch;
            piece[idx] = '\0';
            if (ch != EOF) ungetc(ch, fp);

            if (!isValidIdentifier(piece)) {
                printf("Error: Invalid identifier '%s'\n", piece);
            }
            continue;
        }

//numbers
        if (isdigit((unsigned char)c)) {
            int start = line;
            int idx = 0;
            piece[idx++] = c;
            int ch;
            while ((ch = fgetc(fp)) != EOF && !delimiter(ch)) piece[idx++] = ch;
            piece[idx] = '\0';
            if (ch != EOF) ungetc(ch, fp);

            for (i = 0; piece[i]; i++) {
                if (isalpha((unsigned char)piece[i])) {
                    printf("Error: Invalid number '%s'\n",piece);
                    break;
                }
            }
            continue;
        }

        if (c == '@' || c == '$' || c == '#') {
            piece[0] = c;
            piece[1] = '\0';
            printf("Error: Invalid character '%s'\n", piece);
            continue;
        }
    }

    fclose(fp);
    return 0;
}
