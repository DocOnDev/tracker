#
# Writes a daily record to CFD Data
#
class CFDData
  $LOAD_PATH << './lib'
  require 'json'
  require 'tracker_reader'

  attr_writer :reader

  CFD_STATES = [:icebox, :backlog, :started, :finished, :delivered, :rejected, :done]

  def initialize(io=CFDFileIO.new('cfd.json'))
    @io = io
    @cfd = io.load
  end

  def write
    @io.put(@cfd)
  end

  def add_daily_record(params=nil)
    labels = params[:for] if params
    @reader ||= TrackerReader.new
    record = {}
    CFD_STATES.each{ |state| record[state] = @reader.label(labels).state(state).points}
    @cfd[Date.today.to_s] = record
  end

  def [](_key)
    @cfd[_key]
  end

  def record_count
    @cfd.count
  end
end
