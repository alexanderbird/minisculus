describe Lexer do
  context "#lex" do
    let(:lexer) { Lexer.new }

    context "basic mechanics" do
      before do
        allow_any_instance_of(Lexer).to receive(:token_rules).and_return [
          TokenRule.new(IdentifierToken, /foo/),
          TokenRule.new(IdentifierToken, /bar/),
          TokenRule.new(NewlineNonToken, /\n/)
        ]
      end

      it "returns an empty list when given an empty string as input" do
        expect(lexer.lex "").to eq []
      end

      it "attempts to match each TokenRule to the input" do
        first_token = lexer.lex("barfoo").first
        expect(first_token).to be_kind_of(IdentifierToken)
        expect(first_token.identifier).to eq 'bar'
      end

      it "continues matching TokenRule s until the input is depleted" do
        tokens = lexer.lex("foobarbar")
        expect(tokens.count).to eq 3
        expect(tokens.first.identifier).to eq 'foo'
        expect(tokens.last.identifier).to eq 'bar'
      end

      it "throws a lexer error if no TokenRule s match" do
        expect{lexer.lex("foobarx")}.to raise_error(LexError)
      end

      it "tells you the line and column number of the lex error when it's on the first line" do
        expect{lexer.lex("x")}.to raise_error(LexError, /[Ll]ine 1, column 1/)
      end

      it "tells you the line number of the lex error when it's on subsequent lines" do
        expect{lexer.lex("foo\nbar\nx")}.to raise_error(LexError, /[Ll]ine 3, column 1/)
      end

      it "tells you the column number of the lex error when it's on a later column" do
        expect{lexer.lex("foobarfoox")}.to raise_error(LexError, /[Ll]ine 1, column 10/)
      end

      it "tells you the position of the lex error" do
        expect{lexer.lex("foo\nbar\nfoo\nfoobarx")}.to raise_error(LexError, /[Ll]ine 4, column 7/)
      end

      it "gives you a 10 character hint when you get a lexer error on a long line" do
        expect{lexer.lex("foobarfoox-included not included")}.to raise_error(LexError, /`x-included`/)
      end
      
      it "gives you a shorter character hing when you get a lexer error on a line less than 10 characters" do
        expect{lexer.lex("foobarfoox-short\nnot included")}.to raise_error(LexError, /`x-short`/)
      end
    end

    context "tokenizing" do
      {
        IfToken: 'if',
        ThenToken: 'then',
        WhileToken: 'while',
        DoToken: 'do',
        InputToken: 'input',
        ElseToken: 'else',
        BeginToken: 'begin',
        EndToken: 'end',
        WriteToken: 'write',
        AddToken: '+',
        AssignToken: ':=',
        SubToken: '-',
        MulToken: '*',
        DivToken: '/',
        LeftParenToken: '(',
        RightParenToken: ')',
        SemicolonToken: ';'
      }.each do |token_class, source_code|
        it "lexes #{token_class.to_s}" do
          token = lexer.lex(source_code).first
          expect(token).to be_kind_of Kernel.const_get(token_class)
        end
      end

      it "handles spaces and newlines" do
        expect{ tokens = lexer.lex("begin\nif ( )\nend") }.to_not raise_error
      end

      it "handles identifier tokens" do
        token = lexer.lex("foo").first
        expect(token).to be_kind_of IdentifierToken
        expect(token.identifier).to eq 'foo'
      end

      it "handles number tokens" do
        token = lexer.lex("45").first
        expect(token).to be_kind_of NumberToken
        expect(token.value).to eq 45
      end

    end
  end
end
