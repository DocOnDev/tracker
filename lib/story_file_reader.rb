require 'json'

DEFAULT_STORY_FILE='features/support/story_data.json'

class StoryFileReader
  attr_reader :story_file

  def initialize options = {}
    @story_file = options[:story_file]|| DEFAULT_STORY_FILE
  end

  def read_data
    story_content = File.read(@story_file)
    story_data = JSON.parse(story_content) rescue story_data = {}

    if !valid_story_data?(story_data)
      raise "Invalid Story File Format"
    end

    story_data
  end

  def valid_story_data? data
    valid_data_of_type? data, "story"
  end

  def valid_data_of_type? data, type
    data.length >0 && data[0]["kind"] == type
  end
end