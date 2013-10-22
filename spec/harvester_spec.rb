require 'harvester'
require 'file_reader'

describe Harvester do
  describe '#harvest', :focus => true do
    let(:harvester) { Harvester.new }

    # Harvester reads from a source project and writes transposed data to a repository
    it "raises an error without a parameter" do
      lambda { harvester.harvest }.should raise_error
    end

    it "expects a source" do
      lambda { harvester.harvest( {} ) }.should raise_error("Source Required")
    end

    it "expects a destination" do
      lambda { harvester.harvest( {:source => {:type => :tracker}} ) }.should raise_error("Destination Required")
    end
  end
end
