%{
        #include <iostream>
        #include <stdlib.h>
        #include "parser.tab.h"
        using namespace std;
        int linenum = 1;
%}

%option noyywrap

%%

[ \t\r]+        ;
[\n]            { ++linenum; }
"//".*			;
"\"".*"\""		{ return LITERAL; };
"function"      { return FUNCTION; }
"var"           { return VAR; }
"return"        { return RETURN; }
"if"            { return IF; }
"while"         { return WHILE; }
"for"           { return FOR; }
"typeof"		{ return TYPEOF; }
"in"            { return IN; }
"\."            { return DOT; }
"("             { return LPAREN; }
")"             { return RPAREN; }
"["             { return LSQUARE; }
"]"             { return RSQUARE; }
"{"             { return LCURLY; }
"}"             { return RCURLY; }
"="             { return ASSIGN; }
"=="            { return EQUAL; }
"==="           { return SEQUAL; }
"!="            { return NEQUAL; }
"||"            { return OR; }
"&&"            { return AND; }
"++"            { return INCR; }
"--"            { return DECR; }
"+"             { return ADD; }
"-"             { return MINUS; }
","             { return COMMA; }
";"             { return SEMIC; }
":"             { return COLON; }
"?"             { return QUES; }
[+-]*[0-9]+	{ yylval.ival = atoi(yytext); cout << "INT: " << yytext << endl; return INT; }
[a-zA-Z0-9]+    { yylval.sval = strdup(yytext); cout << yytext << endl; return STRING; }
.                       { yylval.sval = strdup(yytext); cout << yytext << endl; return ARBSTR; }

%%

/*
[0-9]+          { yylval.ival = atoi(yytext); return INT; }
.                       { cerr << "Invalid token " << yytext << endl; exit(1); }
*/