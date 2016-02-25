# Minisculus Compiler
[Assignment documentation](http://pages.cpsc.ucalgary.ca/~robin/class/411/Assignments/2016/minisculus/ass1and2.html)

## Quick Start
1. Install prerequisites ([Ruby 2.x](https://www.ruby-lang.org/en/documentation/installation/) and [bundler](http://bundler.io/))
2. Install dependancies (`bundle install`)
3. Test (optional) (`rspec`)
4. Run `./compile infile.m-`

## Implementation Notes
* Comments are handled by a preprocessor that removes any commented characters other than newlines (so that the line count is preserved)

## Testing
### End-to-end Testing
* [spec/manual_test_cases/src/*](spec/manual_test_cases/src) contains test input files
* [spec/manual_test_cases/bin/*](spec/manual_test_cases/bin) contains test output files
* sample 1-6 and 9 were provided by the instructor
* sample 10-15 were written by me

### Unit Testing for Lexer
* unit tests found in *spec/*
* for a detailed list of unit test cases, run `rspec --format documentation` (or view the results in *doc/unit_test_list.txt*)
  * The key set of tests are for the lex method of the Lexer class (found under Lexer#lex in the unit_test_list)
* As a very rough measure of coverage, for the approximately 325 lines of lexer code that I have written, I have approximately 400 lines of unit tests

## Alternate Usage
* save output to file: `./compile infile.m- > outfile.m-c`
* parse all sample files: `for file in spec/manual_test_cases/src/sample*.m-; do ./compile $file --mode parse > spec/manual_test_cases/bin/$(basename $file)c 2>&1; done`
* generate ast for all: `for file in spec/manual_test_cases/src/sample*.m-; do ./compile $file --mode ast > spec/manual_test_cases/ast/$(basename $file).svg 2>&1; done`
* if you installed ruby at a different path than */urs/local/bin/ruby*: `/path/to/ruby ./compile infile.m-`
 * This is the way to get around the following error: `-bash: ./compile: /usr/local/bin/ruby: bad interpreter: No such file or directory`

## Language Information
### Grammar

    prog -> stmt. 
    stmt -> IF expr thenpart
                | WHILE expr DO stmt
                | INPUT ID
                | ID ASSIGN expr
                | WRITE expr
                | BEGIN stmtlist END. 
    thenpart -> THEN stmt elsepart.
    elsepart -> ELSE stmt.
    stmtlist -> stmt SEMICOLON stmtlist
                |. 
    expr -> term expr'.
    expr' -> ADD term expr'
                |SUB term expr'
                |.
    term -> factor term'.
    term' -> MUL factor term'
                |DIV factor term'
                |.
    factor -> LPAR expr RPAR
                | ID
                | NUM
                | SUB NUM.
                
### Tokens
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


## Compiler Architecture
*What is the purpose/responsability of each class and module?*

#### Compiler Module
Reads from file, acts as foreman of the compilation, and outputs results

#### Preprocessor Class
Filters content in place (e.g. replacing comments with whitespace). Has many PreprocessorRules

###### PreprocessorRule Class
Each instance contains the regex to match and the string to replace it with

#### Lexer Class
Chunks input based on TokenRules, converting each chunk to its corresponding Token. Has many TokenRules

###### TokenRule Class
Each instance contains the class of the token to initialize when tokenizing (subclass of Token Class), and the regular expression to use when tokenizing. If the start of the input string matches that regexp, it gets converted into the token and removed from the input. Otherwise, the fact that it didn't match is indicated. 

###### Token Class and SubClasses
Knows how to interpret the string that was matched to create the token. For example, identifier stores the string bare, number casts it to an integer, and the begin keyword ignores it. Note that all simple Token SubClasses are auto-generated. 

###### TokenList
Array-like interface, but it allows you to save_state (using Momento pattern) and restore it later on. In other words, when you `shift` the head off of a TokenList, it's not gone for good - you can `load_state` later to return to a previous state. 

#### Parser
###### Production and child classes
Given a TokenList and a Gramar, parses head of TokenList or throws exception. Grammar is needed in case one of this production's symbols is a reference to another production. This implements the Collection pattern: a single Production (ie Terminal, NullProduction) can be used in the same way that a collection (ie NonterminalProduction) can. The collection delegates to the items in its collection. 

* **NullProduction** pops nothing, and never fails
* **Terminal** if list head matches Token type, shift it off - otherwise, fail
* **NonterminalProduction** composed of many Productions. If all succeed, then this production succeeds. Otherwise, bubble up the failure message
* **ProductionSet** composed of many Productions, one must succeed, otherwise this Production fails. The Production that parses the most tokens before failing is the one that sets the error message upon failure. 

###### Grammar
Generic class that takes a hash describing the grammar and converts any given rule to a Production object on the fly. Note that the Production is not "deep initialized" - if it refers to another production, only the label is stored. Also has reference to the starting production. 

###### MinisculusGrammar
Concrete implementation of Grammar that describes the Minisculus language. 

#### Other source files of note
* `spec` directory contains all the unit tests
* `Gemfile` contains the dependancy list to be used with bundler tool
* `spec/manual_test_cases/src` contains some sample minisculus code to be parsed
