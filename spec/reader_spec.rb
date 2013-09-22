require 'reader'

describe Reader do
  describe '#read', :focus => true do
    it 'should raise a file not found error when file does not exist' do
      reader = Reader.new('file_not_found.json')
      lambda { reader.read }.should raise_error("No such file or directory - file_not_found.json")
    end

    it 'should raise an error when file is empty' do
      reader = Reader.new('features/support/empty.json')
      lambda { reader.read }.should raise_error("Invalid File Format")
    end

    it 'should raise an error when file format is not correct' do
      reader = Reader.new('features/support/bogus_tracker.json')
      lambda { reader.read }.should raise_error("Invalid File Format")
    end

    it 'should have tracker stories if the file format is correct' do
      reader = Reader.new('features/support/tracker_data.json')
      data = reader.read
      data.story_count > 0
    end

  end
end
