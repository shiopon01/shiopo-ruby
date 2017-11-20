/**
 * @file lex.l
 * @brief shiopo-ruby's lex.l
 * @author shiopon01
 * @date Mon Nov 20 2017
 */

%{
#include <stdio.h>
#include "y.tab.h"

int yywrap (void) {
  return 1;
}

typedef struct parser_state {
  int nerr;
  void *lval;
  const char *fname;
  int lineno;
  int tline;
  /* TODO: should be separated as another context structure */
} parser_state;

static int
lex_return(parser_state *p, int c)
{
  p->lineno = p->tline;
  p->tline = yylineno;
  return c;
}

#define LEX_RETURN(c) return lex_return(p, c)
%}

%option yylineno

%%

"+"  return ADD;
"-"  return SUB;
"*"  return MUL;
"/"  return DIV;
"\n" return CR;

[1-9][0-9]* {
  double temp;
  sscanf (yytext, "%lf", &temp);
  yylval.double_value = temp;
  return DOUBLE_LITERAL;
}
[0-9]*\.[0-9]* {
  double temp;
  sscanf (yytext, "%lf", &temp);
  yylval.double_value = temp;
  return DOUBLE_LITERAL;
}

%%
