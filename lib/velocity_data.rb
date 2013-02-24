class VelocityData
  $LOAD_PATH << './lib'
  require 'json'
  require 'tracker_reader'

  attr_writer :reader

  CFD_STATES = [:icebox, :backlog, :started, :finished, :delivered, :rejected, :done]

  def initialize(io=VelocityFileIO.new('velocity.json'))
    @io = io
    @velocity = io.load
  end

  def write(file_name=@file_name)
    @io.put(@velocity)
  end

  def update_current_velocity(params=nil)
    labels = params[:for] if params
    @reader ||= TrackerReader.new
    record = {:points => @reader.iteration(:current).label(labels).state(:done).points}
    @velocity[Date.today.to_s] = record
  end

  def [](_key)
    @velocity[_key]
  end

  def record_count
    @velocity.count
  end
end

