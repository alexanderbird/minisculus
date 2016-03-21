class MinisculusPlusParser < RLTK::Parser
  def self.nullable return_value = []
    self.clause('') { || return_value }
  end
  
  production(:prog, 'block') { |b| b }
  
  production(:block, 'declarations program_body') { |d, p| d + p }
  
  production(:declarations) do
    clause('declaration SEMICOLON declarations') { |d, _, ds| [d] + ds }
    nullable
  end

  production(:declaration) do
    clause('var_declaration') { |v| v }
    clause('fun_declaration') { |f| f }
  end

  production(:var_declaration, 'VAR ID array_dimensions COLON type') { |_, i, a, _, t| Variable.new(i, a, t)  }

  production(:type) do
    clause('INT') { |_| IntegerType.new }
    clause('REAL') { |_| Real.new }
    clause('BOOL') {|_| Boolean.new }
  end

  production(:array_dimensions) do
    clause('SLPAR expr SRPAR array_dimensions') { |_, e, _, a| e + a }
    nullable
  end

  production(:fun_declaration, 'FUN ID param_list COLON type CLPAR declarations fun_body CRPAR') { |_, i, p, _, t, _, d, f, _| FunctionDeclaration.new(i, p, t, d, f) }

  production(:param_list, 'LPAR parameters RPAR') { |_, p, _| p }

  production(:parameters) do
    clause('basic_declaration more_parameters') { |b, m| [b] + m }
    nullable
  end

  production(:more_parameters) do
    clause('COMMA basic_declaration more_parameters') { |_, b, m| [b] + m }
    nullable
  end

  production(:basic_declaration, 'ID basic_array_dimensions COLON type') { |i, b, _, t| Parameter.new(i, b, t) }

  production(:basic_array_dimensions) do
    clause('SLPAR SRPAR basic_array_dimensions') { |_, _, b|  1 + b }
    nullable 0
  end

  production(:program_body) do
    nullable
  end

  production(:fun_body, 'BEGIN prog_stmts RETURN expr SEMICOLON END') { |_, p, _, e, _, _| p + [Return.new(e)]}

  production(:prog_stmts) do
    clause('prog_stmt SEMICOLON prog_stmts') { |p, _, ps| [p] + ps }
    nullable
  end

  production(:prog_stmt) do
		clause('IF expr THEN prog_stmt ELSE prog_stmt') { |_, c, i, p, _, e | Condition.new(c, i, e) }
		clause('WHILE expr DO prog_stmt') { |_, e, _, p| While.new(e, p) }
		clause('READ identifier') { |_, i| Read.new(i, nil) }
		clause('identifier ASSIGN expr') { |i, _, e| Assignment.new(i.name, [], e)}
		clause('PRINT expr') { |_, e| Print.new(e) }
		clause('CLPAR block CRPAR ') { |_, b, _| b }
  end

  production(:identifier, 'ID array_dimensions') { |i, a| Identifier.new(i, a) } 

  production(:expr) do
    clause('expr OR bint_term') { |e, _, b| App.new(Or.new, [e, b]) }
    clause('bint_term') { |b| b }
  end

  production(:bint_term) do
    clause('bint_term AND bint_factor') { |t, _ , f| App.new(And.new, [t, f])}
    clause('bint_factor') { |b| b }
  end

  production(:bint_factor) do
    clause('NOT bint_factor') { |_, f| App.new(Not.new, [f]) }
    clause('int_expr compare_op int_expr') { |i1, o, i2| App.new(o, [i1, i2])  }
    clause('int_expr') { |i| i }
  end

  production(:compare_op) do
    clause('EQUAL') { |_| Equal.new }
    clause('LT') { |_| LessThan.new }
    clause('GT') { |_| GreaterThan.new }
    clause('LE') { |_| LessThanOrEqual.new }
    clause('GE') { |_| GreaterThanOrEqual.new }
  end

  production(:int_expr) do
    clause('int_expr addop int_term') { |e, a, t| App.new(Add.new, [e,t]) }
    clause('int_term') { |i| i }
  end

  production(:addop) do
    clause('ADD') { |_| Add.new }
    clause('SUB') { |_| Substitute.new }
  end

  production(:int_term) do
    clause('int_term mulop int_factor') { |t, o, f| App.new(o, [t,f]) }
    clause('int_factor') { |i| i }
  end

  production(:mulop) do
    clause('MUL') { |_| Multiply.new }
    clause('DIV') { |_| Divide.new }
  end

  production(:int_factor) do
    clause('LPAR expr RPAR') { |_, e, _| e }
    clause('SIZE LPAR ID basic_array_dimensions RPAR') { |_, _, i, a, _| Size.new(i, a) }
    clause('FLOAT LPAR expr RPAR') { |_, _, e, _| App.new(Float.new, [e]) }
    clause('FLOOR LPAR expr RPAR') { |_, _, e, _| App.new(Floor.new, [e]) }
    clause('CEIL LPAR expr RPAR') { |_, _, e, _| App.new(Ceiling.new, [e]) }
    clause('ID modifier_list') { |i, m| Identifier.new(i, [m]) }
    clause('IVAL') { |i| IntegerValue.new(i) }
    clause('RVAL') { |r| RealValue.new(r) }
    clause('BVAL') { |b| BooleanValue.new(b) }
    clause('SUB int_factor') { |_, i| App.new(Substitute.new, [i]) }
  end

  production(:modifier_list) do
    clause('LPAR arguments RPAR') { |_, a, _| App.new(FunctionOperation.new, [a]) }
    clause('array_dimensions') { |a| Expression.new } # TODO
  end

  production(:arguments) do
    clause('expr more_arguments') { |e, m| e + m }
    nullable
  end

  production(:more_arguments) do
    clause('COMMA expr more_arguments') { |_, e, m| e + m }
    nullable
  end

  finalize({ use: 'parser.tbl' })
end
