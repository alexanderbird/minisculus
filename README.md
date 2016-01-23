# Minisculus
[Assignment documentation](http://pages.cpsc.ucalgary.ca/~robin/class/411/Assignments/2016/minisculus/ass1and2.html)
## Grammar

    prog -> stmt. 
    stmt -> IF expr THEN stmt ELSE stmt
                | WHILE expr DO stmt
                | INPUT ID
                | ID ASSIGN expr
                | WRITE expr
                | BEGIN stmtlist END. 
    stmtlist -> stmtlist stmt SEMICOLON
                |. 
    expr -> expr addop term 
                | term. 
    addop -> ADD
                | SUB. 
    term -> term mulop factor 
                | factor. 
    mulop -> MUL
                | DIV. 
    factor -> LPAR expr RPAR
                | ID
                | NUM
                | SUB NUM.
                
## Tokens
| Pattern | Token   |
|---------|---------|
| "if"    | IF      |
| "then"  | THEN    |
| "while" | WHILE   |
| "do"    | DO      |
| "input" | INPUT   |
| "else"  | ELSE    |
| "begin" | BEGIN   |
| "end"   | END     |
| "write" | WRITE   |
| {alpha}[{digit}{alpha}]* | ID (identifier) |
| {digit}+ | NUM (positive integer) |
| "+"     | ADD     |
| ":="    | ASSIGN  |
| "-"     | SUB     |
| "*"     | MUL     |
| "/"     | DIV     |
| "("     | LPAR    |
| ")"     | RPAR    |
| ";"     | SEMICOLON |

# Compiler Usage
*run all commands from project root*
## Prerequisites
* Ruby 2.x (in `/usr/local/bin/ruby`)
* bundler gem

## Install
`bundle`

## Test
`rspec`

## Run
`./mnc infile > outfile`

Or, to compile every file in `sample_code`: `for file in sample_code/src/sample*.m-; do ./mnc $file > sample_code/bin/$(basename $file)c 2>&1; done`


# Compiler Architecture
## Compiler Module
Reads from file, acts as foreman of the compilation, and outputs results

## Preprocessor Class
Filters content in place (e.g. replacing comments with whitespace). Has many PreprocessorRules

### PreprocessorRule Class
Each instance contains the regex to match and the string to replace it with

## Lexer Class
Chunks input based on TokenRules, converting each chunk to its corresponding Token. Has many TokenRules

### TokenRule Class
Each instance contains the class of the token to initialize when tokenizing (subclass of Token Class), and the regular expression to use when tokenizing. If the start of the input string matches that regexp, it gets converted into the token and removed from the input. Otherwise, the fact that it didn't match is indicated. 

### Token Class and SubClasses
Knows how to interpret the string that was matched to create the token. For example, identifier stores the string bare, number casts it to an integer, and the begin keyword ignores it. Note that all simple Token SubClasses are auto-generated. 

## Other source files of note
* `spec` directory contains all the unit tests
* `Gemfile` contains the dependancy list to be used with bundler tool
* `sample_code` contains some sample minisculus code to be parsed
* `compiler/lexer/tokens/.generate_simple_token_classes.rb` does what the file name says
