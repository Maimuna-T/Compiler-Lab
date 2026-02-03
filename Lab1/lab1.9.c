#include <stdio.h>
#include <string.h>
#include <ctype.h>

#define MAX 1000
#define MAX_TOKENS 2000

typedef struct {
    char lexeme[MAX];
    char type[50];
    int count;
} Token;

char *keywords[] = {
    "int","float","char","double","return","if","else","for","while","do","void","long",
    "short","switch","case","break","continue","static","struct"
};
int keyword_count = 20;

Token tokens[MAX_TOKENS];
int token_index = 0;

// Check if keyword
int isKeyword(char str[]) {
    int i;
    for(i=0;i<keyword_count;i++)
        if(strcmp(str, keywords[i])==0) return 1;
    return 0;
}

// Check if operator character
int isOperatorChar(char c) {
    char ops[] = "+-*/%=<>&|!^";
    int i;
    for(i=0;i<strlen(ops);i++)
        if(c==ops[i]) return 1;
    return 0;
}

// Check if special symbol
int isSpecialSymbol(char c) {
    char syms[] = "{}()[];,.:";
    int i;
    for(i=0;i<strlen(syms);i++)
        if(c==syms[i]) return 1;
    return 0;
}

// Check valid string literal
int isValidString(char *str) {
    int len = strlen(str);
    if(len<2) return 0;
    if(str[0]!='"' || str[len-1]!='"') return 0;
    int i;
    for(i=1;i<len-1;i++)
        if(str[i]=='"' && str[i-1]!='\\') return 0;
    return 1;
}

// Check valid char constant
int isValidChar(char *str) {
    int len = strlen(str);
    if(len<3) return 0;
    if(str[0]!='\'' || str[len-1]!='\'') return 0;
    if(len==3 && str[1]!='\\') return 1;
    if(len==4 && str[1]=='\\') return 1;
    return 0;
}

// Add or update token count
void addToken(char *lex, char *type) {
    int i;
    for(i=0;i<token_index;i++) {
        if(strcmp(tokens[i].lexeme, lex)==0 && strcmp(tokens[i].type, type)==0) {
            tokens[i].count++;
            return;
        }
    }
    strcpy(tokens[token_index].lexeme, lex);
    strcpy(tokens[token_index].type, type);
    tokens[token_index].count = 1;
    token_index++;
}

int main() {
    FILE *fp = fopen("maimuna.txt","r");
    if(!fp) { printf("Cannot open file!\n"); return 1; }

    char line[500];
    int in_multiline_comment = 0;

    while(fgets(line,sizeof(line),fp)) {
        int i;
        for(i=0; line[i]; ) {
            if(isspace(line[i])) { i++; continue; }

            //----------------- Skip comments -----------------
            if(!in_multiline_comment && line[i]=='/' && line[i+1]=='/') break;
            if(!in_multiline_comment && line[i]=='/' && line[i+1]=='*') { in_multiline_comment=1; i+=2; continue; }
            if(in_multiline_comment) {
                if(line[i]=='*' && line[i+1]=='/') { in_multiline_comment=0; i+=2; continue; }
                i++;
                continue;
            }

            //----------------- String literal -----------------
            if(line[i]=='"') {
                char piece[MAX]; int j=0;
                piece[j++] = line[i++];
                int closed=0, l;
                for(l=i; line[l]; l++) {
                    piece[j++] = line[l];
                    if(line[l]=='"' && piece[j-2]!='\\') { closed=1; i=l+1; break; }
                }
                piece[j]='\0';
                if(closed && isValidString(piece)) addToken(piece, "string_literal");
                else addToken(piece, "invalid string");
                continue;
            }

            //----------------- Character constant -----------------
            if(line[i]=='\'') {
                char piece[10]; int j=0;
                piece[j++] = line[i++];
                int closed=0, l;
                for(l=i; line[l]; l++) {
                    piece[j++] = line[l];
                    if(line[l]=='\'' && piece[j-2]!='\\') { closed=1; i=l+1; break; }
                }
                piece[j]='\0';
                if(closed && isValidChar(piece)) addToken(piece, "character_constant");
                else addToken(piece, "invalid character");
                continue;
            }

            //----------------- Identifier / Keyword -----------------
            if(isalpha(line[i]) || line[i]=='_') {
                char piece[MAX]; int j=0;
                piece[j++] = line[i++];
                int l;
                for(l=i; isalnum(line[l]) || line[l]=='_'; l++) piece[j++] = line[l];
                piece[j]='\0';
                i = l;
                if(isKeyword(piece)) addToken(piece, "keyword");
                else addToken(piece, "identifier");
                continue;
            }

            //----------------- Constants -----------------
            if(isdigit(line[i])) {
                char piece[MAX]; int j=0; int dot_count=0;
                piece[j++] = line[i++];
                int l;
                for(l=i; isdigit(line[l]) || line[l]=='.'; l++) {
                    if(line[l]=='.') dot_count++;
                    piece[j++] = line[l];
                }
                piece[j]='\0';
                i = l;
                if(dot_count<=1) addToken(piece, "constant");
                else addToken(piece, "invalid constant");
                continue;
            }

            //----------------- Operators -----------------
            if(isOperatorChar(line[i])) {
                char op[3]; op[0]=line[i]; op[2]='\0';
                if((line[i]=='<' || line[i]=='>' || line[i]=='=' || line[i]=='!') && line[i+1]=='=') {
                    op[1]='='; op[2]='\0'; i+=2;
                } else if(line[i]=='&' && line[i+1]=='&') {
                    op[1]='&'; op[2]='\0'; i+=2;
                } else if(line[i]=='|' && line[i+1]=='|') {
                    op[1]='|'; op[2]='\0'; i+=2;
                } else { op[1]='\0'; i++; }
                addToken(op, "operator");
                continue;
            }

            //----------------- Special symbols -----------------
            if(isSpecialSymbol(line[i])) {
                char op[2]; op[0]=line[i]; op[1]='\0';
                addToken(op, "special_symbol");
                i++;
                continue;
            }

            //----------------- Unknown -----------------
            char op[2]; op[0]=line[i]; op[1]='\0';
            addToken(op, "unknown");
            i++;
        }
    }

    fclose(fp);

    //----------------- Print all tokens with counts -----------------
    int i;
    for(i=0;i<token_index;i++) {
        printf("<%s , %s> : %d\n", tokens[i].lexeme, tokens[i].type, tokens[i].count);
    }

    return 0;
}
