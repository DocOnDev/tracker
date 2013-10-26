require 'json'
require 'from_pivotal_transformer'
require 'story_collection'
require 'story_file_reader'
require 'person_file_reader'

class FileReader
  CONFIG_FILE='features/support/config.yml'

  attr_reader :person_file

  def initialize options = {}
    config_file = options[:config_file] || CONFIG_FILE
    config = config_file ? YAML::load(File.open(config_file)) : {}
    @person_file_reader = PersonFileReader.new(config)
    @story_file_reader = StoryFileReader.new(config)
  end

  def read

    story_data = @story_file_reader.read_data
    person_data = @person_file_reader.read_data

    return FromPivotalTransformer.transform({:stories => story_data, :people => person_data})
  end

end

