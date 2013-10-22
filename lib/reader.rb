require 'tracker_reader'
require 'file_reader'

class Reader
  def self.create type=:tracker
    case type
    when :tracker
      return TrackerReader.new
    when :file
      return FileReader.new
    else
      raise "Invalid Reader Type Specified"
    end
  end
end
