require 'yaml'
require 'from_pivotal_transformer'
require 'story_collection'
require 'story_file_reader'
require 'person_file_reader'

#
# Reads data from both the person and story file, returning a single transformed object
#

class FileReader
  CONFIG_FILE='features/support/config.yml'

  attr_reader :person_file

  def initialize options = {}
    config_file = options[:config_file] || CONFIG_FILE
    p_config = config_file ? YAML::load(File.open(config_file)) : {}
    s_config = p_config.clone
    @person_file_reader = PersonFileReader.new(p_config)
    @story_file_reader = StoryFileReader.new(s_config)
  end

  def read
    puts "Story File Reader File: #{@story_file_reader.story_file}"
    story_data = @story_file_reader.read_data
    person_data = @person_file_reader.read_data

    return FromPivotalTransformer.transform({:stories => story_data, :people => person_data})
  end

end

