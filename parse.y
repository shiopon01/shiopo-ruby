/**
 * @file parse.y
 * @brief shiopo-ruby's parse.y
 * @author shiopon01
 * @date Mon Nov 20 2017
 */

%{
#include <stdio.h>
#include <stdlib.h>
#define YYDEBUG 1

extern int linenum;
%}

%union {
  int    int_value;
  double double_value;
}

%token <double_value> DOUBLE_LITERAL
%token ADD SUB MUL DIV CR
%type <double_value> expression term primary_expression

%%

line_list
  : line
  | line_list line
  ;
line
  : expression CR
  {
    printf(">> %lf\n", $1);
  }
expression
  : term
  | expression ADD term
  {
    $$ = $1 + $3;
  }
  | expression SUB term
  {
    $$ = $1 - $3;
  }
  ;
term
  : primary_expression
  | term MUL primary_expression
  {
    $$ = $1 * $3;
  }
  | term DIV primary_expression
  {
    $$ = $1 / $3;
  }
  ;
primary_expression
  : DOUBLE_LITERAL
  ;

%%

int yyerror (char const *str)
{
  extern char *yytext;
  fprintf(stderr, "parser error near %s\n", yytext);
  return 0;
}

int
main(int argc, const char**argv)
{
  const char *prog = argv[0];
  const char *e_prog = NULL;

  if (argc < 2) {
    fprintf(stderr, "arg Error\n");
    exit(1);
  }

  // options
  while (argc > 1 && argv[1][0] == '-') {
    printf("while %s\n", argv[1]);

    const char *s = argv[1] + 1;
    while (*s) {
      switch (*s) {
      case 'v':
        break;

      case 'e':
        if (s[1] == '\0') {
          e_prog = argv[2];
        } else {
          /* e_prog = &s[1]; // String of after `-e` */
        }
        goto next_arg;

      default:
        fprintf(stderr, "%s: unknown option -%c\n", prog, *s);
        exit(1);
      }
      s++;
    }

  next_arg:
    argc--;
    argv++;
    printf("next_arg %s\n", argv[0]);
  }

  /* FILE* fp = fopen(argv[1], "rb"); */
  /* if (fp == NULL) { */
  /*   fprintf(stderr, "file open Error\n"); */
  /*   exit(1); */
  /* } */

  extern int yyparse(void);
  extern FILE *yyin;
  yyin = stdin;

  if (yyparse()) {
    fprintf(stderr, "Error\n");
    exit(1);
  }
}
