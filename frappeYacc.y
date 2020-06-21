%{
	#include <ctype.h>
	#include <stdio.h>
	#define YYDEBUG 1
	int yylex();
	int yyparse();
extern int line_num;
extern FILE *yyin;
FILE *fp;

int main(int argc, char** argv)
{
 if(argc == 2){
	 yyin = fopen(argv[1],"r");
	 if(yyin == NULL){
		printf("\nWrong definition of file ! \n");
	 }
	 else
	 {
		printf("\nParsing...\nFILE : %s\n",argv[1]);
		yyparse();
	 }
 }
 return 0;
}

%}

%token IDENTIFIER INPUT RETURN EXIT PRINT

%token OR AND NOT

%token CHAR INT INT_ARRAY CHAR_ARRAY VOID CONSTANT

%token MUL_OPER DIV_OPER EQ_SYM ASS_SYM PLUS_OPER MINUS_OPER

%token LESS_THAN GREATER_THAN NOT_EQUAL LESS_OR_EQUAL GREATER_OR_EQUAL

%token CASE DEFAULT IF ELSE SWITCH WHILE DO FOR BREAK 

%token EXTENDS CONSTRUCTOR CLASS MAIN METHOD

%token OPENING_BRACKET CLOSING_BRACKET OPENING_PARENTHESIS CLOSING_PARENTHESIS

%token SEMICOLON COLON COMMA

%error-verbose

%left '+' '-' '*' '/'
 
%right '='

%%

class
	: CLASS IDENTIFIER class_block	
	;
	
	
class_block
	: extend OPENING_BRACKET constructor method CLOSING_BRACKET main_block
	;
	
constructor
	: CONSTRUCTOR formal_par block constructor
	|
	;
	
formal_par
	: OPENING_PARENTHESIS formal_par_list CLOSING_PARENTHESIS
	| OPENING_PARENTHESIS CLOSING_PARENTHESIS
	;
	
formal_par_list
	: formal_par_item COMMA formal_par_list 
	| formal_par_item
	;

	
formal_par_item
	: var_type
	;
	
var_type
	: INT
	| CHAR
	| INT_ARRAY
	| CHAR_ARRAY
	;
	
block
	: OPENING_BRACKET sequence CLOSING_BRACKET
	;
	
sequence
	: statement SEMICOLON sequence 
	| statement SEMICOLON
	;
	
statement
	: assignment
	| call_method
	| if
	| dowhile
	| switch
	| while
	| exit
	| return
	| break
	| print
	| input
	;
	
call_method
	: IDENTIFIER actual_par
	;
	
break
	: BREAK
	;
	
assignment
	: IDENTIFIER ASS_SYM expression
	;

if
	: IF OPENING_PARENTHESIS condition CLOSING_PARENTHESIS block else
	;
	
else
	: ELSE block
	|
	;
	
dowhile
	: DO block WHILE OPENING_PARENTHESIS condition CLOSING_PARENTHESIS
	;
	
switch
	: SWITCH OPENING_PARENTHESIS IDENTIFIER CLOSING_PARENTHESIS case
	;
	
while
	: WHILE OPENING_PARENTHESIS condition CLOSING_PARENTHESIS block
	;
	
exit
	: EXIT
	;
	
return
	: RETURN OPENING_PARENTHESIS expression CLOSING_PARENTHESIS
	;
	
print
	: PRINT OPENING_PARENTHESIS expression CLOSING_PARENTHESIS
	;
	
input
	: INPUT IDENTIFIER
	;
	
extend
	: EXTENDS IDENTIFIER
	|
	;

expression
	: optional_sign term expression_part2
	;
	
expression_part2
	: add_oper term expression_part2
	|
	;
	
optional_sign
	: add_oper
	|
	;
	
mul_oper
	: MUL_OPER
	| DIV_OPER
	;

add_oper
	: PLUS_OPER
	| MINUS_OPER
	;
	
term
	: factor term_part2
	;
	
term_part2
	: mul_oper factor term_part2
	| 
	;
	
factor
	: CONSTANT
	| OPENING_PARENTHESIS expression CLOSING_PARENTHESIS
	| IDENTIFIER idtail
	;
	
idtail
	: actual_par
	|
	;	
actual_par
	: OPENING_PARENTHESIS actual_par_list CLOSING_PARENTHESIS
	| OPENING_PARENTHESIS CLOSING_PARENTHESIS
	;
	
actual_par_list
	: actual_par_item
	| actual_par_item COMMA actual_par_list
	;
	
actual_par_item
	: var_type expression
	;
	
type
	: VOID
	| var_type
	;
	
case
	: CONSTANT COLON block case
	| DEFAULT COLON block
	;
	
condition
	: boolterm OR boolterm
	| boolterm
	;
	
boolterm
	: boolfactor AND boolfactor
	| boolfactor
	;
	
boolfactor
	: NOT '[' condition ']'
	| '[' condition ']'
	| expression relational_oper expression
	;
	
relational_oper
	: EQ_SYM
	| LESS_THAN
	| GREATER_THAN
	| LESS_OR_EQUAL
	| GREATER_OR_EQUAL
	| NOT_EQUAL
	;
	
main_block
	: MAIN block
	;
	
method
	: type IDENTIFIER formal_par block method	
	|
	;


%%


#include <stdio.h>

extern char yytext[];
extern int column;

yyerror(s)
char *s;
{
	fflush(stdout);
	printf("\n%*s\n%*s\n", column, "^", column, s);
}