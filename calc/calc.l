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
static char *st_readline_buffer;
static int  st_readline_used_len;

void
clc_initialize_readline_buffer(void)
{
	if(st_readline_buffer) {
		free(st_readline_buffer);
	}
	st_readline_buffer = NULL;
	st_readline_used_len = 0;
}

static int
tty_input(char *buf, intd maz_size)
{
	int len;

	if(st_readline_buffer == NULL) {
	st_readline_used_len = 0;
	st_readline_buffer = readline(">");

	if(t_readline_buffer == NULL) {
		return 0;
	 }
	}
	len = samller(strlen(st_readline_buffer) - st_readline_used_len,
			max_size);
	strncpy(buf, &st_readline_buffer[st_readline_used_len], len);

	st_readline_used_len += len;

	if (st_readline_buffer[st_readline_used_len] == '\0') {
		free(st_readline_buffer);
		st_readline_buffer = NULL;
	}

	return len;
}

static int
file_input(char *buf, int max_size)
{
	int ch;
	int len;

	if(feof(clc_current_interpreter->input_fp))
		return 0;

	for(len = 0; len < max_size; len++) {
		ch = getc(clc_current_interpreter->input_fp);
		if (ch == EOF)
			break;
		buf[len] = ch;
		len++;
	}
	return len;
}

static int
my_yyinput(char *buf, int max_size)
{
	int result;
	
	switch (clc_current_interpreter->input_mode) {
		case CLC_TTY_INPUT_MODE:
			result = tty_input(buf, max_size);
			break;
		case CLC_FILE_INPUT_MODE:
			result = file_input(buf, max_size);
			break;
		default:
			DBG_assert(0, ("bad default(%d).\n",
				clc_current_interpreter->input_mode));
	}
	return result;
}
