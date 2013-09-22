require 'transformer'
require 'json'

describe Transformer do

  describe "#transform" do
    it "raises a No data received error when there is no json" do
      transformer = Transformer.new
      lambda { transformer.transform "" }.should raise_error("No data received")
    end

    it "returns an empty story collection when the json is empty" do
      # transformer = Transformer.new
      # result = transformer.transform JSON.parse("[]")
      # result.should be_kind_of Stories
    end
   
  end

end
