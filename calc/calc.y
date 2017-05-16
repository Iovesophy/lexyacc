%{
#include <stdio.h>
#include "calc.h"
#define YYDEBUG 1
%}
%union {
	char		*identifier;
	ParameterList	*parameter_list;
	Expression	*expression;
}
%token <expression>	INT_LITERAL
%token <expression>	DOUBLE_LITERAL
%token <identifier>	IDENTIFIER
%token DEFINE IF ELSE WHILE LP RP LC RC SEMICOLON COMMA ASSIGN EQ NE GT GE LT LE ADD SUB MUL DIV MOD
%type  <parameter_list> parameter_list
%type  <expression> expression expression_list
	equality_expression relational_expression
	additive_expression multiplicative_expression
	unary_expression postfix_expression praimary_expression
	if_expression while_expression
%%
translation_unit
	: definition_or_expression
	| translation_unit definition_or_expression
	;
definition_or_expression
	: function_definition
	| expression SEMICOLON
	{
		clc_eval_expression($)
	}
	| error
	{
		yyclearin;
		yyerrok;
		clc_reopen_current_storage();
	}
	;
function_definition
	: DEFINE IDENTIFIER LP parameter_list RP LC expression_list RC
	| DEFINE IDENTIFIER LP Parameter_list RP expression_list END
	{
		clc_function_define($2, $4, $7);
	}
	| DEFINE IDENTIFIER LP RP LC expression_list RC
	{
		clc_function_define($2, NULL, $6);
	}
	;
parameter_list
	: IDENTIFIER
	{
		$$ = clc_create_parameter($1);
	}
	| parameter_list COMMA IDENTIFIER
	{
		$$ = clc_chain_parameter($1, $3);
	}
	;
expression_list
	: expression
	{
		$$ = clc_create_expression_list($1);
	}
	| expression_list COMMA expression
	{
		$$ = clc_chain_expression_list($1, $3);
	}
	;
equality_expression
	: relational_expression
	| equality_expression EQ relational_expression
	{
		$$ = clc_create_binary_expression(EQ_EXPRESSION, $1, $3);
	}
	| equality_expression NE relational_expression
	{
		$$ = clc_create_binary_expression(NE_EXPRESSION, $1, $3);
	}
	;
relational_expression
	: additive_expression
	| relational_expression GT additive_expression
	{
		$$ = clc_create_binary_expression(GT_EXPRESSION, $1, $3);
	}
	| relational_expression GE additive_expression
	{
		$$ = clc_create_binary_expression(GE_EXPRESSION, $1, $3);
	}
	| relational_expression LT additive_expression
	{
		$$ = clc_create_binary_expression(LT_EXPRESSION, $1, $3);
	}
	| relational_expression LE additive_expression
	{
		$$ = clc_create_binary_expression(LE_EXPRESSION, $1, $3);
	}
	;
additive_expression
	: multiplicative_expression
	| additive_expression ADD multiplicative_expression
	{
		$$ = clc_create_binary_expression(ADD_EXPRESSION, $1, $3);
	}
	| additive_expression SUB multiplicative_expression
	{
		$$ = clc_create_binary_expression(SUB_EXPRESSION, $1, $3);
	}
	;
multiplicative_expression
	: unary_expression
	| multiplicative_expression MUL unary_expression
	{
		$$ = clc_create_binary_expression(MUL_EXPRESSION, $1, $3);
	}
	| multiplicative_expression DIV unary_expression
	{
		$$ = clc_create_binary_expression(DIV_EXPRESSION, $1, $3);
	}
	| multiplicative_expression MOD unary_expression
	{
		$$ = clc_create_binary_expression(MOD_EXPRESSION, $1, $3);
	}
	;
unary_expression
	: postfix_expression
	|SUB unary_expression
	{
		$$ = clc_create_minus_expression($2);
	}
	;
postfix_expression
	: primary_expression
	;
primary_expression
	: IDENTIFIER LP expression_list RP
	{
		$$ = clc_create_function_call_expression($1, $3);
	}
	| IDENTIFIER LP RP
	{
		$$ = clc_create_function_call_expression($1, NULL);
	}
	| if_expression
	| while_expression
	| LP expression RP
	{
		$$ = $2;
	}
	| IDENTIFIER
	{
		$$ = clc_create_identifier_expression($1);
	}
	| INT_LITERAL
	| DOUBLE_LITERAL
	;
if_expression
	: IF expression LC expression_list RC
	{
		$$ = clc_create_if_expression($2, $4, NULL);
	}
	| IF expression LC expression_list RC ELSE LC expression_list RC
	{
		$$ = clc_create_if_expression($2, $4, $8);
	}
	;
while_expression
	: WHILE expression LC expression_list RC
	{
		$$ = clc_create_while_expression($2, $4);
	}
	;
%%

