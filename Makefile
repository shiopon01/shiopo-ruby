YACC = bison -y -d
LEX = flex
CC = gcc

all: calc
.PHONY: all

calc: parse.y lex.l
	$(YACC) -o y.tab.c parse.y
	$(LEX) lex.l
	$(CC) -o calc y.tab.c lex.yy.c

clean:
	rm -f y.tab.c y.tab.h lex.yy.c
	rm -f calc
.PHONY: clean
