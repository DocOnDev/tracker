class Harvester
  def initialize reader
    @reader = reader
  end

  def retrieve_data
    @reader.read
  end
end

