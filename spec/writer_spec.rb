require 'writer'
require 'factory_girl'
require 'story_collection'
require 'story'
require 'json'
require 'to_cloudant_transformer'

NEW_FILE = 'features/support/new_file.json'
EXISTING_FILE = 'features/support/existing_file.json'

def remove_file name
  File.delete(name) if File.exist?(name)
end

describe Writer, :focus => true do
  describe '#write' do
    it 'should create a new file when the file does not exist' do
      remove_file NEW_FILE
      writer = Writer.new(NEW_FILE)
      writer.write
      File.exist?(NEW_FILE).should == true
    end

    it 'accepts a story collection' do
      writer = Writer.new(EXISTING_FILE)
      story_collection = StoryCollection.new

      writer.write story_collection
    end

    it 'uses the transformer' do
      transformer_mock = double(ToCloudantTransformer)
      writer = Writer.new(EXISTING_FILE, transformer_mock)

      transformer_mock.should_receive(:transform)

      writer.write
    end

    #it 'writes the story collection data to the file' do
    #  file_name = 'features/support/temp_file.json'
    #  remove_file file_name
    #
    #  current_record_name = Time.now.to_s
    #  writer = Writer.new(file_name)
    #  story_collection = StoryCollection.new
    #  first_story = Story.new
    #  first_story.name = current_record_name
    #  story_collection << first_story
    #  writer.write story_collection
    #
    #  new_data = JSON.parse(File.read(file_name))
    #
    #  new_data[0]["name"].should == current_record_name
    #
    #end
  end
end
