require 'json'
require 'transformer'
require 'story_collection'

class Reader
  def initialize story_file_name, person_file_name
    @story_file_name = story_file_name
    @person_file_name = person_file_name
  end

  def read
    content = File.read(@story_file_name)
    story_data = JSON.parse(content) rescue story_data = {}

    person_content = File.read(@person_file_name)
    person_data = JSON.parse(person_content) rescue person_data = {}

    if !valid_person_content?(person_data)
      raise "Invalid Person File Format"
    end

    return Transformer.transform(story_data) if valid_story_content?(story_data)
    raise "Invalid Story File Format"
  end

  private

  def valid_person_content? data
    data.length > 0 && data[0]["kind"] == "project_membership"
  end

  def valid_story_content? data
    data.length > 0 && data[0]["kind"] == "story"
  end
end

