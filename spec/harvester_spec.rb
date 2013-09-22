require 'harvester'
require 'reader'

describe Harvester do
  describe '#retreive_data', :focus => true do
    it 'should call the reader.read method' do
      reader = Reader.new('file_not_found.json')
      reader.should_receive(:read)
      harvester = Harvester.new(reader)
      harvester.retrieve_data
    end
  end
end
