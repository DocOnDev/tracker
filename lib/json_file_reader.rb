require 'json'

DEFAULT_FILE='features/support/empty.json'
DEFAULT_FILE_TYPE='none'
DEFAULT_FILE_DESCRIPTION='bogus'

class JSONFileReader
  attr_reader :file, :type

  def initialize options = {}
    @file = options[:file] || DEFAULT_FILE
    @type = options[:type] || DEFAULT_FILE_TYPE
    @description = options[:description] || DEFAULT_FILE_DESCRIPTION
  end

  def read_data
    content = File.read(@file)
    data = JSON.parse(content) rescue data = {}
    raise "Invalid #{@description} File Format".split.map(&:capitalize).join(' ') if !valid_data?(data)
    data
  end

  def valid_data? data
    data.length >0 && data[0]["kind"] == @type
  end
end