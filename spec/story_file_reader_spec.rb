require 'story_file_reader'

describe StoryFileReader do
  let(:story_file) { 'features/support/story_data.json' }
  let(:missing_file) { 'file_not_found.json' }
  let(:bogus_file) { 'features/support/bogus_tracker.json' }
  let(:empty_file) { 'features/support/empty.json' }

  describe "#initialize", :focus => true do

    describe '#initialize' do
      it 'accepts a hash parameter' do
        lambda { reader = StoryFileReader.new({ :story_file => missing_file }) }.should_not raise_error
      end
    end

    it 'sets a default for story file' do
      reader = StoryFileReader.new
      reader.story_file.should == DEFAULT_STORY_FILE
    end

    it 'uses the hash to set the story file' do
      reader = StoryFileReader.new({ :story_file => missing_file })
      reader.story_file.should == missing_file
    end

    it 'gives precedence to specified story file' do
      reader = StoryFileReader.new({ :story_file => missing_file })
      reader.story_file.should == missing_file
    end
  end

  describe "#read", :focus => true do
    it 'raises a file not found error when file does not exist' do
      reader = StoryFileReader.new({ :story_file => missing_file })
      lambda { reader.read_data }.should raise_error("No such file or directory - file_not_found.json")
    end

    it 'raises an error when file is empty' do
      reader = StoryFileReader.new({ :story_file => empty_file })
      lambda { reader.read_data }.should raise_error("Invalid Story File Format")
    end

    it 'raises an error when file format is not correct' do
      reader = StoryFileReader.new({ :story_file => bogus_file })
      lambda { reader.read_data }.should raise_error("Invalid Story File Format")
    end
  end
end