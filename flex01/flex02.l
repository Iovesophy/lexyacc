%{
int yywrap(void) 
{
return 1;
}
%}
%%
[\n\t]
"'"."'"		printf("CH: %s\n", yytext);
"'\\"."'"	printf("CH: %s\n", yytext);
"\""[^\"]*"\""  printf("ST: %s\n", yytext);
[_A-Za-z][_A-Za-z0-9]*	printf("ID: %s\n", yytext);
"0"[xX][0-9a-fA-F]+	printf("NM: %s\n", yytext);
[0-9.]+[lLuUfF]?	printf("NM: %s\n", yytext);
[0-9.]+[eE][+-][0-9]+	printf("NM: %s\n", yytext);
.			printf("SY: %s\n", yytext);
%%
void
main(){
	yylex();
}
