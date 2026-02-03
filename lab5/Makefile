CC = gcc
CFLAGS = -w

all: icg

icg.tab.c icg.tab.h: icg.y
	bison -d icg.y

lex.yy.c: icg.l icg.tab.h
	flex icg.l

icg: lex.yy.c icg.tab.c
	$(CC) $(CFLAGS) -o icg icg.tab.c lex.yy.c -lm

run: icg
	./icg

clean:
	rm -f icg lex.yy.c icg.tab.c icg.tab.h icg

.PHONY: all run clean
