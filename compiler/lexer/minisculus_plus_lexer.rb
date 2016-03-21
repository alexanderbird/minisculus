class MinisculusPlusLexer < RLTK::Lexer
  rule(/\s/)
  rule(/a/) { :A }
  rule(/b/) { :B }
  rule(/c/) { :C }


	# Comment rules.
  rule(/%.*$/)
	rule(/\/\*/)                       { push_state :multiline_comment }
	rule(/\/\*/,  :multiline_comment)  { push_state :multiline_comment } # allow nesting
	rule(/\*\//,  :multiline_comment)  { pop_state }
  rule(/%.*$/,  :multiline_comment)
	rule(/\n/,    :multiline_comment)
	rule(/./,     :multiline_comment)
end
