require 'pivotal_reader'
require 'file_reader'

class Reader
  def self.create type=:tracker, options={}
    case type
    when :tracker
      return PivotalReader.new options
    when :file
      return FileReader.new options
    else
      raise "Invalid Reader Type Specified"
    end
  end
end
