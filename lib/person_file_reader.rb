require 'json_file_reader'

DEFAULT_PERSON_FILE='features/support/person_data.json'

class PersonFileReader
  def initialize options = {}
    options[:file] ||= options[:person_file] || DEFAULT_PERSON_FILE
    options[:type] = "project_membership"
    options[:description] = "person"
    @json_reader = JSONFileReader.new(options)
  end

  def person_file
    @json_reader.file
  end

  def read_data
    @json_reader.read_data
  end
end