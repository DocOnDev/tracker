require 'transformer'
require 'json'

describe Transformer do

  describe "#transform" do
    it "raises an error when the json is empty" do
      transformer = Transformer.new
      lambda { transformer.transform JSON.parse("[]") }.should raise_error("Invalid data source")
    end

    

   
  end

end
