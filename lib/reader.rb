require 'json'

class Reader
  def initialize file_name
    @file_name = file_name
  end

  def read
    content = File.read(@file_name)
    data = JSON.parse(content) rescue data = {}
    return data if valid_content?(data)
    raise "Invalid File Format"
  end

  private

  def valid_content? data
    data.length > 0 && data[0]["kind"] == "story"
  end
end
