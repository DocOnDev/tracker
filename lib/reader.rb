require 'json'
require 'transformer'
require 'story_collection'

class Reader
  STORY_FILE='features/support/story_data.json'
  PERSON_FILE='features/support/person_data.json'
  CONFIG_FILE='features/support/config.yml'

  attr_reader :story_file, :person_file

  def initialize options = {}
    config_file = options[:config_file] || CONFIG_FILE
    config = config_file ? YAML::load(File.open(config_file)) : {}
    @story_file = options[:story_file] || config['story_file'] || STORY_FILE
    @person_file = options[:person_file] || config['person_file'] || PERSON_FILE
  end

  def read
    content = File.read(@story_file)
    story_data = JSON.parse(content) rescue story_data = {}

    person_content = File.read(@person_file)
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

