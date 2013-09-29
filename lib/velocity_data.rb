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

  def write(file_name=@story_file_name)
    @io.put(@velocity)
  end

  def update_current_velocity(params=nil)
    labels = params[:for] if params
    @reader ||= TrackerReader.new
    record = @reader.iteration(:current).label(labels).velocity
    velocity_date = @reader.iteration(:current).end_date
    @velocity[velocity_date.strftime('%Y-%m-%d')] = record
  end

  def [](_key)
    @velocity[_key]
  end

  def record_count
    @velocity.count
  end
end

