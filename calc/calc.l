%{
#undef YY_INPUT
#define YY_INPUT(buf, result, max_size) (result = my_yyinput(buf, max_size))
#include <stdio.h>
#include <string.h>
#include <readline/readline.h>
#include "calc.h"
#include "y.tab.h"

static int my_yyinput(char *buf, int max_size);
%}
%start COMMENT

%%
<INITIAL>"define"	return DEFINE;
<INITIAL>"if"		return IF;
<INITIAL>"else"		return ELSE;
<INITIAL>"while"	return WHILE;
<INITIAL>"("		return LP;
<INITIAL>")"		return RP;
<INITIAL>"{"		return LC;
<INITIAL>"}"		return RC;
<INITIAL>";"		return SEMICOLON;
<INITIAL>","		return COMMA;
<INITIAL>"="		return ASSIGN;
<INITIAL>"=="		return EQ;
<INITIAL>"!="		return NE;
<INITIAL>">"		return GT;
<INITIAL>"<"		return ;
