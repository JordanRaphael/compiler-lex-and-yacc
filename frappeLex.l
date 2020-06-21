digit [0-9]
letter [a-zA-Z]

%{
#include <stdio.h>
#include "y.tab.h"

void count();
%}

%%
[0-9]+ {count(); return(CONSTANT);}
"int" {count(); return(INT);}
"int array" {count(); return(INT_ARRAY);}
"do" {count(); return(DO);}
"else" {count(); return(ELSE);}
"print" {count(); return(PRINT);}
"return" {count(); return(RETURN);}
"break" {count(); return(BREAK);}
"char" {count(); return(CHAR);}
"char array" {count(); return(CHAR_ARRAY);}
"while" {count(); return(WHILE);}
"exit" {count(); return(EXIT);}
"input" {count(); return(INPUT);}
"switch" {count(); return(SWITCH);}
"void" {count(); return(VOID);}
"and" {count(); return(AND);}
"or" {count(); return(OR);}
"not" {count(); return(NOT);}
"if" {count(); return(IF);}
"method" {count(); return(METHOD);}
"default" {count(); return(DEFAULT);}
"extends" {count(); return(EXTENDS);}
"constructor" {count(); return(CONSTRUCTOR);}
"main" {count(); return(MAIN);}
"class" {count(); return(CLASS);}
[a-zA-Z][a-zA-Z0-9]* {count(); return(IDENTIFIER);}
"+" {count(); return(PLUS_OPER);}
"-" {count(); return(MINUS_OPER);}
"*" {count(); return(MUL_OPER);}
"/" {count(); return(DIV_OPER);}
"==" {count(); return(EQ_SYM);}
"=" {count(); return(ASS_SYM);}
"<" {count(); return(LESS_THAN);}
">" {count(); return(GREATER_THAN);}
"!=" {count(); return(NOT_EQUAL);}
"<=" {count(); return(LESS_OR_EQUAL);}
">=" {count(); return(GREATER_OR_EQUAL);}
"{" {count(); return(OPENING_BRACKET);}
"}" {count(); return(CLOSING_BRACKET);}
"(" {count(); return(OPENING_PARENTHESIS);}
")" {count(); return(CLOSING_PARENTHESIS);}
":" {count(); return(COLON);}
";" {count(); return(SEMICOLON);}
"," {count(); return(COMMA);}
"/*" {comment();}
[ \t\v\n\f]	{count();}
. { /* we are ignoring bad characters */}
%%

comment()
{
	char c, c1;

loop:
	while ((c = input()) != '*' && c != 0)
		putchar(c);

	if ((c1 = input()) != '/' && c != 0)
	{
		unput(c1);
		goto loop;
	}

	if (c != 0)
		putchar(c1);
}

int yywrap()
{
  return(1);
}

int column = 0;

void count()
{
	int i;

	for (i = 0; yytext[i] != '\0'; i++)
		if (yytext[i] == '\n')
			column = 0;
		else if (yytext[i] == '\t')
			column += 8 - (column % 8);
		else
			column++;

	ECHO;
}
