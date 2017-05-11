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
<INITIAL>">="		return GE;
<INITIAL>"<"		return LT;
<INITIAL>"<="		return LE;
<INITIAL>"+"		return ADD;
<INITIAL>"-"		return SUB;
<INITIAL>"*"		return MUL;
<INITIAL>"/"		return DIV;
<INITIAL>"%"		return MOD;
<INITIAL>[A-Za-z_][A-Za-z_0-9]* {
	yylval.identifier = clc_malloc(strlen(yytext) + 1);
	strcpy(yylval.identifier, yytext);
	return IDENTIFIER;
}
<INITIAL>[1-9][0-9]* {
	Expression *expression = clc_allox_expression(INT_EXPRESSION);
	sscanf(yytext, "%d", &expression->u.int_value);
	yylval.expression = expression;
	return INT_LITERAL;
}
<INITIAL>"0" {
	Expression *expression = clc_allox_expression(INT_EXPRESSION);
	expression->u.int_value = 0;
	yylval.expression = expression;
	return INT_LITERAL;
}
<INITIAL>[0-9]*\.[0-9]* {
	Expression *expression = clc_alloc_expression(DOUBLE_EXPRESSION);
	sscanf(yytext, "%lf", &expression->u.double_value);
	yylval.expression = expression;
	return DOUBLE_LITERAL;
}
<INITIAL>[ \t\n];
<INITIAL>^#	BEGIN COMMENT;
<INITIAL>.	clc_compile_error(CHARACTER_INVALID_ERR, NULL);
<COMMENT>\n	BEGIN INITIAL;
<COMMENT>.	;
%%


