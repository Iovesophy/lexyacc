%{
int yywrap(void){return 1;}
%}
%%
[A-Za-z][A-Za-z0-9]*	printf("ID: %s\n", yytext);
[0-9]+			printf("NM: %s\n", yytext);
[0-9]+"."[0-9]+		printf("NM: %s\n", yytext);
.			printf("SY: %s\n", yytext);
%%
void main() {
	yylex();
}
