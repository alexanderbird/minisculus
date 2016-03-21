class MinisculusPlusLexer < RLTK::Lexer
  # Ignore whitespace
  rule(/\s/)

	# Comments rules
  rule(/%.*$/)
	rule(/\/\*/)                       { push_state :multiline_comment }
	rule(/\/\*/,  :multiline_comment)  { push_state :multiline_comment } # allow nesting
	rule(/\*\//,  :multiline_comment)  { pop_state }
  rule(/%.*$/,  :multiline_comment)
	rule(/\n/,    :multiline_comment)
	rule(/./,     :multiline_comment)

  # Operators
  # Math
  rule(/[+]/)                     { :ADD }
  rule(/-/)                       { :SUB }
  rule(/[*]/)                     { :MUL }
  rule(/\//)                      { :DIV }

  # Boolean
  rule(/&&/)                      { :AND }
  rule(/||/)                      { :OR }
  rule(/not/)                     { :NOT }

  rule(/=/)                       { :EQUAL } 
  rule(/</)                       { :LT } 
  rule(/>/)                       { :GT } 
  rule(/=</)                      { :LE } 
  rule(/>=/)                      { :GE }

  # Lists and grouping
  rule(/\(/)                      { :LPAR }
  rule(/\)/)                      { :RPAR }
  rule(/{/)                       { :CLPAR }
  rule(/}/)                       { :CRPAR }
  rule(/\[/)                      { :SLPAR }
  rule(/\]/)                      { :SRPAR }

  rule(/:/)                       { :COLON }
  rule(/;/)                       { :SEMICOLON }
  rule(/,/)                       { :COMMA } 

  # Flow control
  rule(/if/)                      { :IF }
  rule(/then/)                    { :THEN }
  rule(/while/)                   { :WHILE }
  rule(/do/)                      { :DO }
  rule(/else/)                    { :ELSE }
  rule(/begin/)                   { :BEGIN }
  rule(/end/)                     { :END }

  # Data types
  rule(/int/)                     { :INT }
  rule(/bool/)                    { :BOOL }
  rule(/real/)                    { :REAL }
  rule(/var/)                     { :VAR }
  rule(/float/)                   { :FLOAT }

  # Built-in functions
  rule(/:=/)                      { :ASSIGN }
  rule(/size/)                    { :SIZE }
  rule(/read/)                    { :READ }
  rule(/print/)                   { :PRINT }
  rule(/floor/)                   { :FLOOR }
  rule(/ceil/)                    { :CEIL }

  # Keywords
  rule(/fun/)                     { :FUN }
  rule(/return/)                  { :RETURN }

  # Literals
  rule(/[a-zA-Z][_a-zA-Z0-9]*/)   { |id| [:ID, id] }
  rule(/[0-9]+/)                  { |int| [:IVAL, int.to_i] }
  rule(/[0-9]*\.[0-9]+/)          { |real| [:RVAL, real.to_f] }
  rule(/false/)                   { [:BVAL, false] } 
  rule(/true/)                    { [:BVAL, true] }
end
