require 'json'
require 'transformer'
require 'story_collection'

class Reader
  def initialize story_file_name
    @file_name = story_file_name
  end

  def read
    content = File.read(@file_name)
    story_data = JSON.parse(content) rescue story_data = {}
    return Transformer.transform(story_data) if valid_content?(story_data)
    raise "Invalid File Format"
  end

  private

  def valid_content? data
    data.length > 0 && data[0]["kind"] == "story"
  end
end

