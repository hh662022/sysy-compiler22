%option noyywrap
%option nounput
%option noinput

%{

#include <cstdlib>
#include <string>
#include "sysy.tab.hpp"
#include "AST.hpp"

using namespace std;

%}

/* 空白符和注释 */
WhiteSpace    [ \t\n\r]*
LineComment   "//".*
BlockComment  "/*"([^*]*|(\*+[^/]))*"*/"

/* 标识符 */
Identifier    [a-zA-Z_][a-zA-Z0-9_]*

/* 整数字面量 */
Decimal       [1-9][0-9]*
Octal         0[0-7]*
Hexadecimal   0[xX][0-9a-fA-F]+

UnaryOperator \!  
MulOperator   \*|\/|\%
AddOperator   \+|\-
RelOperator   <|>|<=|>=
EqOperator    ==|\!=
LAndOperator  &&
LOrOperator   \|\|


%%

{WhiteSpace}    { /* 忽略, 不做任何操作 */ }
{LineComment}   { /* 忽略, 不做任何操作 */ }
{BlockComment}  { /* 忽略, 不做任何操作 */ }

"int"           { return INT; }
"return"        { return RETURN; }
"const"         { return CONST; }
"void"          { return VOID; }
"if"            { return IF; }
"else"          { return ELSE; }
"while"         { return WHILE; }
"break"         { return BREAK; }
"continue"      { return CONTINUE; }

{Identifier}    { yylval.str_val = new string(yytext); return IDENT; }

{Decimal}       { yylval.int_val = strtol(yytext, nullptr, 0); return INT_CONST; }
{Octal}         { yylval.int_val = strtol(yytext, nullptr, 0); return INT_CONST; }
{Hexadecimal}   { yylval.int_val = strtol(yytext, nullptr, 0); return INT_CONST; }

{UnaryOperator}      { yylval.str_val = new string(yytext); return UNARYOP; }
{MulOperator}      { yylval.str_val = new string(yytext); return MULOP; }
{AddOperator}      { yylval.str_val = new string(yytext); return ADDOP; }
{RelOperator}      { yylval.str_val = new string(yytext); return RELOP; }
{EqOperator}      { yylval.str_val = new string(yytext); return EQOP; }
{LAndOperator}      { yylval.str_val = new string(yytext); return LANDOP; }
{LOrOperator}      { yylval.str_val = new string(yytext); return LOROP; }

.               { return yytext[0]; }

%%
