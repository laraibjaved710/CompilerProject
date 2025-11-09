%option noyywrap
%{
#include <stdio.h>
#include <string.h>

int line = 1;
void print_token(const char* type, const char* lexeme) {
    printf("Line %d: %s -> %s\n", line, type, lexeme);
}
%}

DIGIT     [0-9]
ID_START  [A-Za-z_]
ID_CONT   [A-Za-z0-9_]

%%

\n                      { line++; }

"/*"([^*]|\*+[^*/])*\*+"/"  { char *p = yytext; for(; *p; ++p) if(*p=='\n') ++line; }
"//".*                   { }

(nikalo|dalo|agar|warna|jabtak|karlo|forbro|wapas|textbro|boolbro|sach|jhoot|ginti|pointbro|rukja)\b
                        { print_token("KEYWORD", yytext); }

">+"      { print_token("OPERATOR", yytext); }
"<-"      { print_token("OPERATOR", yytext); }
"**"      { print_token("OPERATOR", yytext); }
"%bro"    { print_token("OPERATOR", yytext); }
"+bro"    { print_token("OPERATOR", yytext); }
"-bro"    { print_token("OPERATOR", yytext); }
">>"      { print_token("OPERATOR", yytext); }
"<<"      { print_token("OPERATOR", yytext); }
"?="      { print_token("OPERATOR", yytext); }
"&bro"    { print_token("OPERATOR", yytext); }
"!"       { print_token("OPERATOR", yytext); }
"="       { print_token("OPERATOR", yytext); }

[{()}[\];,]   { print_token("PUNCT", yytext); }

\"([^\\\n\"]|\\.)*\"       { print_token("STRING", yytext); }
'([^\\\n]|\\.)'            { print_token("CHAR", yytext); }

{DIGIT}+"."{DIGIT}+([eE][+-]?{DIGIT}+)? { print_token("NUMBER(FLOAT)", yytext); }
{DIGIT}+([eE][+-]?{DIGIT}+)?            { print_token("NUMBER(EXP)", yytext); }
{DIGIT}+                                { print_token("NUMBER(INT)", yytext); }

{ID_START}{ID_CONT}*    { print_token("IDENTIFIER", yytext); }

[ \t\r]+                { }

.                       { char buf[128]; snprintf(buf,sizeof(buf),"%s (invalid token)",yytext); print_token("ERROR",buf); }

%%

int main(int argc, char **argv){
    if(argc > 1) {
        yyin = fopen(argv[1], "r");
        if(!yyin) { perror("fopen"); return 1; }
    }
    yylex();
    if(yyin && yyin != stdin) fclose(yyin);
    return 0;
}
