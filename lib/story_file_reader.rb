require 'json_file_reader'

DEFAULT_STORY_FILE='features/support/story_data.json'

class StoryFileReader
  def initialize options = {}
    options[:file] ||= options[:story_file] || DEFAULT_STORY_FILE
    options[:type] = options[:description] = "story"
    @json_reader = JSONFileReader.new(options)
  end

  def story_file
    @json_reader.file
  end

  def read_data
    @json_reader.read_data
  end
end