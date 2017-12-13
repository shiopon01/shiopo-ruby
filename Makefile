YACC = bison -y -d
LEX = flex
CC = gcc

all: srb
.PHONY: all

srb: parse.y lex.l
	$(YACC) -o y.tab.c parse.y
	$(LEX) lex.l
	$(CC) -o ./bin/srb y.tab.c lex.yy.c

test:
	./bin/srb ./examples/01hello.srb
.PHONY: test

clean:
	rm -f y.tab.c y.tab.h lex.yy.c
.PHONY: clean
