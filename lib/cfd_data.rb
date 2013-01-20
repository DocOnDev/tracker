class CFDData
  $LOAD_PATH << './lib'
  require 'json'
  require 'tracker_reader'

  attr_writer :reader

  CFD_STATES = [:icebox, :backlog, :started, :finished, :delivered, :accepted, :rejected]

  def initialize(file_name='cfd.json')
    @file_name = file_name
    @cfd = {}
    @cfd = JSON.parse(IO.read(@file_name)) if File.exists?(@file_name)
  end

  def write(file_name=@file_name)
    File.open(file_name,"w") { |f| f.write(@cfd.to_json) }
  end

  def add_daily_record
    @reader ||= TrackerReader.new
    record = {}
    CFD_STATES.each{ |state| record[state] = @reader.state(state).points}
    @cfd[Date.today.to_s] = record
  end

  def [](_key)
    @cfd[_key]
  end

  def record_count
    @cfd.count
  end
end
