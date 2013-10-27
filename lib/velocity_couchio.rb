require 'couchio'

class VelocityCouchIO
  def initialize(db_name=nil)
    @couchio = CouchIO.new(db_name, 'velocity')
  end

  def load
    @couchio.load
  end

  def put(vel)
    @couchio.put vel
  end

end
