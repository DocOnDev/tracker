class CFDData
  require 'json'
  def initialize(file_name='cfd.json')
    @file_name = file_name
    @cfd = {}
    @cfd = JSON.parse(IO.read(@file_name)) if File.exists?(@file_name)
  end

  def record_count
    @cfd.count
  end
end
