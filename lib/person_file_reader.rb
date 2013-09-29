require 'json'

DEFAULT_PERSON_FILE='features/support/person_data.json'

class PersonFileReader
  attr_reader :person_file

  def initialize options = {}
    @person_file = options[:person_file]|| DEFAULT_PERSON_FILE
  end

  def read_data
    person_content = File.read(@person_file)
    person_data = JSON.parse(person_content) rescue person_data = {}

    if !valid_story_data?(person_data)
      raise "Invalid Person File Format"
    end

    person_data
  end

  def valid_story_data? data
    valid_data_of_type? data, "project_membership"
  end

  def valid_data_of_type? data, type
    data.length >0 && data[0]["kind"] == type
  end
end