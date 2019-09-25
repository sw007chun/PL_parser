%{
	#include <cstdio>
	#include <iostream>
	using namespace std;
	extern int yylex();
	extern void yyerror(const char *p);
	extern FILE *yyin;
	extern int linenum;
%}

%union {
//	int ival;
	char *sval;
}

%start prog

%token FUNCTION RETURN VAR IF FOR WHILE
%token LPAREN RPAREN LSQUARE RSQUARE LCURLY RCURLY
%token ASSIGN EQUAL SEQUAL NEQUAL
%token OR AND
%token INCR DECR TYPEOF IN LITERAL
%token ADD MINUS
%token DOT COMMA SEMIC COLON QUES

//%token <ival> INT
%token <sval> STRING ARBSTR INT

//%type <ival> exprs
%type <sval> str //rvalue ternary conds funcdef exprs attrs assign attr cond factor

%left COMMA
%right ASSIGN
%right QUES
%left OR
%left AND
%left EQUAL NEQUAL SEQUAL
%left ADD MINUS
%left INCR DECR TYPEOF
%left LCURLY RCURLY
%left DOT LSQUARE RSQUARE
%left LPAREN RPAREN

%%

prog :
	stmts
	|
	;
stmts :
	stmts stmt
	| stmt
	;
stmt :
	instr
	| funcdef
	;
funcdef :
	FUNCTION STRING LPAREN args RPAREN block
	| FUNCTION LPAREN args RPAREN block
	;
args :
	args COMMA STRING
	| STRING
	;
block :
	LCURLY instrs RCURLY
	;
instrs :
	instrs instr
	| instr
	;
instr :
	IF LPAREN conds RPAREN block
	| WHILE LPAREN conds RPAREN block
	| WHILE LPAREN assign RPAREN block
	| FOR LPAREN STRING IN attrs RPAREN block
	| VAR attrs SEMIC
	| VAR assign SEMIC
	| RETURN rvalue SEMIC
	| factor SEMIC 
	| assign SEMIC
	| SEMIC
	;
construct :
	construct COMMA init
	| init
	;
init :
	attrs COLON attrs  // {cout << $1 << " " << $3 << endl;}
	;
ternary :
	conds QUES rvalue COLON rvalue
	;
assign :
	attrs ASSIGN conds //{cout << "1: " << $1 << endl;}
	| attrs ASSIGN funcdef
	;
conds :
	conds and_or cond
	| cond
	;
cond :
	cond comp_op exprs // { cout << "comp " << $1 << " " << $3 << endl; }
	| exprs
	;
exprs :
	exprs add_op factor  
	| factor  
	;
factor :
	LPAREN exprs RPAREN
	| LCURLY construct RCURLY
	| attrs	
	| funcalls 
	| attrs inc_op 		
	| inc_op attrs 
	| TYPEOF attrs
	;
rvalue :
	ternary
	| conds 
	| funcdef
	;
funcalls :
	funcalls DOT funcall
	| funcall
	;
funcall :
	attrs LPAREN attrs RPAREN
	| attrs LPAREN RPAREN
	;
attrs :
	attrs attr		
	| str
	| literal
	;
attr :
	DOT str					//	{ $$ = $2; }	
	| LSQUARE rvalue RSQUARE   // { $$ = $2; }
	;
str :
	STRING	
	;
literal :
	LITERAL 
	| INT
	;
comp_op :
    EQUAL | SEQUAL | NEQUAL
    ;
and_or :
	AND | OR
	;
inc_op :
	INCR | DECR
	;
add_op :
    ADD | MINUS 
    ;
%%

int main(int argc, char* argv[]) {
	if (argc < 2) {
		cout << "Wrong number of input. Should be ./parser inputfile.name" << endl;
		return -1;
	}

	FILE *myfile = fopen(argv[1], "r");

	if (!myfile) {
		cout << "Can't open file: " << argv[1] << endl;
		return -1;
	}

	yyin = myfile;
	yyparse();
}

void yyerror(const char *s) {
	cout << "Line " << linenum << " Error Message: " << s << endl;
	exit(-1);
}
