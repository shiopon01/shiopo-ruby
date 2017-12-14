/**
 * @file parse.y
 * @brief shiopo-ruby's parse.y
 * @author shiopon01
 * @date Mon Nov 20 2017
 */

%{
#include <stdio.h>
#include <stdlib.h>
#define FALSE 0
#define TRUE 1
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
    printf("%lf\n", $1);
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
  extern int yydebug;
  // yydebug = 1;

  const char *prog = argv[0];
  const char *e_prog = NULL;
  int version = FALSE;
  // parser_state state;

  // options
  while (argc > 1 && argv[1][0] == '-') {
    const char *s = argv[1] + 1;

    while (*s) {
      switch (*s) {
      case 'v':
        version = TRUE;
        break;

      case 'e':
        printf("moji %c\n", *s);
        if (s[1] == '\0') {
          e_prog = argv[2];
        } else {
          fprintf(stderr, "%s: unknown option -%s\n", prog, s);
          /* e_prog = ; // String of after `-e` */
        }
        goto next_arg;

      default:
        fprintf(stderr, "%s: unknown option -%s\n", prog, s);
        goto next_arg;
      }
      s++;
    }

  next_arg:
    argc--;
    argv++;
  }

  if (argc == 1) {
    puts("no args err");
  }

  if (e_prog) {
  } else if (version) {
    puts("version 0.00");
    exit(0);
  }

  FILE* fp = fopen(argv[1], "rb");
  if (fp == NULL) {
    fprintf(stderr, "file open Error\n");
    exit(1);
  }

  extern FILE *yyin;
  yyin = fp;

  if (yyparse()) {
    fprintf(stderr, "parse error!!!!!!!1\n");
    exit(1);
  }

  return 0;
}
