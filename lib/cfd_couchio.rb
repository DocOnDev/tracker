require 'couchrest'
CLOUDANT_USER = 'docondev' #'shalmordinfrosequeedderb'
CLOUDANT_PASS = 'Agil3cloud' #'nSG4S4nqKYWiSJNSv3n6xM3M'
COUCH_STORE = "https://#{CLOUDANT_USER}:#{CLOUDANT_PASS}@docondev.cloudant.com/"

class CFDCouchIO
  def initialize(db_name='devspect')
    @db_name = db_name
    @end_point = COUCH_STORE+@db_name+'/'
  end

  def load
    cfd = {}
    @db = CouchRest.database(@end_point)
    cfd = @db.documents
    cfd
  end

  def put(cfd)
    new_record = {"_id" => "cfd-#{cfd.keys.last}", "type" => "cfd", "project" => @db_name}
    new_record["date"] = cfd.keys.last.split("-").map(&:to_i)
    new_record["points"] = cfd.values.last
    @db.save_doc(new_record)
  end

end
