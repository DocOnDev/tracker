require 'couchio'

class CFDCouchIO
  def initialize(db_name=nil)
    @couchio = CouchIO.new(db_name, 'cfd')
  end

  def load
    @couchio.load
  end

  def put(cfd)
    @couchio.put cfd
  end
end
