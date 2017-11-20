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
%}

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
