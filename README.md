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
