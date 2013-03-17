require 'couchrest'
CLOUDANT_USER = 'docondev' #'shalmordinfrosequeedderb'
CLOUDANT_PASS = 'Agil3cloud' #'nSG4S4nqKYWiSJNSv3n6xM3M'
COUCH_STORE = "https://#{CLOUDANT_USER}:#{CLOUDANT_PASS}@docondev.cloudant.com/"

class CFDCouchIO
  def initialize(db_name='devspect')
    @db_name = db_name
    @end_point = "#{COUCH_STORE}#{@db_name}/"
  end

  def load
    cfd = {}
    @db = CouchRest.database(@end_point)
    cfd = @db.view('points/cfd')
    cfd
  end

  def put(cfd)
    doc_id = "cfd-#{cfd.keys.last}"
    begin
      doc = @db.get(doc_id)
    rescue
      doc = CouchRest::Document.new("_id" => doc_id, "type" => "cfd", "project" => @db_name)
      @db.save_doc(doc)
      doc = @db.get(doc_id)
    end

    doc["date"] = cfd.keys.last.split("-").map(&:to_i)
    doc["points"] = cfd.values.last
    doc.save
  end

end
