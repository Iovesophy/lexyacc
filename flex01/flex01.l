%{
int yywrap(void){return 1;}
%}
%%
[A-Za-z0-9]+	printf("ID: %s\n", yytext);
[\r\n\t]
.	printf("SY: %s\n", yytext);
%%
void main() {
	yylex();
}
