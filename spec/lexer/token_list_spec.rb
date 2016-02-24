describe TokenList do
  let(:list) { TokenList.new }

  context "ancestry" do
    it "is an array" do
      expect(list).to be_kind_of Array
    end
    
    let(:accepted_methods) {[ :<<, :shift, :first, :last, :each, :count ]}

    it "does not expose array methods" do
      array_instance_methods = Array.instance_methods - Object.instance_methods
      (array_instance_methods - accepted_methods).each do |method|
        expect(list.private_methods).to include method
      end
    end

    it "exposes certain permitted methods" do
      accepted_methods.each do |method|
        expect(list.public_methods).to include method
      end
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
