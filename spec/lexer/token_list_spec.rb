describe TokenList do
  let(:list) { TokenList.new }

  context "#initialize" do
    it "allows you to initialize it with an array" do
      list = TokenList.new [:foo, :bar]
      expect(list.shift).to eq :foo
    end
  end

  context "#shift" do
    it "returns the first item in the list" do
      list << 1
      expect(list.shift).to eq 1
    end

    it "removes that item from the list" do
      list << 1
      list << 2
      list.shift
      expect(list.shift).to eq 2
    end
  end

  context "built-in array functions" do
    before do
      list << 1
      list << 2
      list << 3
      list << 4
      list.shift
      list.shift
    end

    it "#count does not include `shift`ed items" do
      expect(list.count).to eq 2
    end

    it "#to_a does not inlcude `shift`ed items" do
      expect(list.to_a).to eq [3,4]
    end

    it "#first does not include `shift`ed items" do
      expect(list.first).to eq 3
    end

    it "#each does not include `shift`ed items" do
      items = []
      list.each do |item|
        items << item
      end
      expect(items.count).to eq 2
    end

    it "delegates last to internal array" do
      expect(list.last).to eq 4
    end
  end

  context "#==" do
    it "is equal to the corresponding array" do
      expect(TokenList.new([:foo])).to eq [:foo]
    end

    it "is equal to a different TokenList with the same list" do
      expect(TokenList.new([:foo])).to eq TokenList.new([:foo])
    end
  end

  context "#save_state" do
    it "returns a TokenListState" do
      expect(list.save_state.class).to eq TokenList::SavedState
    end
  end

  context "#load_state" do
    it "restores the previously shifted items" do
      list << 1
      list << 2
      list << 3
      list << 4
      state = list.save_state
      list.shift # remove 1
      list.shift # remove 2
      expect(list.shift).to eq 3
      list.load_state state
      expect(list.shift).to eq 1
    end
  end
end
