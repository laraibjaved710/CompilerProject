%option noyywrap

%{
#include <stdio.h>
#include <string.h>

FILE *tokenFile;
FILE *errorFile;

void print_token(const char *token_name, const char *lexeme) {
    fprintf(tokenFile, "<%s, %s>\n", token_name, lexeme);
}

void print_error(const char *lexeme) {
    fprintf(errorFile, "Unknown token: %s\n", lexeme);
}
%}

FLOAT           [0-9]*\.[0-9]+([eE][+-]?[0-9]+)?
INT             [0-9]+
STRING          \"([^\\\"]|\\.)*\"
CHAR            \'([^\\\n]|\\.)\'
ID_START        [A-Za-z_]
ID_CONT         [A-Za-z_]
WHITESPACE      [ \t\r\n]+
COMMENT_SL      "//".*
COMMENT_ML      "/\*([^*]|\*+[^*/])*\*+/"

%%

{WHITESPACE}
{COMMENT_SL}
{COMMENT_ML}

(nikalo|dalo|agar|warna|jabtak|karlo|forbro|wapas|textbro|boolbro|sach|jhoot|ginti|pointbro|rukja)\b    { print_token("KEYWORD", yytext); }

">+"        { print_token("OPERATOR", yytext); }
"<-"        { print_token("OPERATOR", yytext); }
"**"        { print_token("OPERATOR", yytext); }
"%bro"      { print_token("OPERATOR", yytext); }
"+bro"      { print_token("OPERATOR", yytext); }
"-bro"      { print_token("OPERATOR", yytext); }
">>"        { print_token("OPERATOR", yytext); }
"<<"        { print_token("OPERATOR", yytext); }
"?="        { print_token("OPERATOR", yytext); }
"&bro"      { print_token("OPERATOR", yytext); }
"!"         { print_token("OPERATOR", yytext); }
"="         { print_token("OPERATOR", yytext); }

"{"         { print_token("LBRACE", yytext); }
"}"         { print_token("RBRACE", yytext); }
"("         { print_token("LPAREN", yytext); }
")"         { print_token("RPAREN", yytext); }
"["         { print_token("LBRACKET", yytext); }
"]"         { print_token("RBRACKET", yytext); }
";"         { print_token("SEMI", yytext); }
","         { print_token("COMMA", yytext); }

{STRING}    { print_token("STRING", yytext); }
{CHAR}      { print_token("CHAR", yytext); }
{FLOAT}     { print_token("FLOAT", yytext); }
{INT}       { print_token("INTEGER", yytext); }

{ID_START}{ID_CONT}*    { print_token("IDENTIFIER", yytext); }

.                       { print_error(yytext); }

%%

int main(int argc, char *argv[]) {
    if(argc < 2) {
        printf("Usage: lexer <source_file>\n");
        return 1;
    }

    FILE *inputFile = fopen(argv[1], "r");
    if(!inputFile) {
        perror("Error opening input file");
        return 1;
    }

    tokenFile = fopen("tokens.txt", "w");
    if(!tokenFile) {
        perror("Cannot create tokens.txt");
        return 1;
    }

    errorFile = fopen("errors.txt", "w");
    if(!errorFile) {
        perror("Cannot create errors.txt");
        return 1;
    }

    yyin = inputFile;
    yylex();

    fclose(inputFile);
    fclose(tokenFile);
    fclose(errorFile);

    return 0;
}

