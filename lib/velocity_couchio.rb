require 'couchrest'
CLOUDANT_USER = 'docondev' #'shalmordinfrosequeedderb'
CLOUDANT_PASS = 'Agil3cloud' #'nSG4S4nqKYWiSJNSv3n6xM3M'
COUCH_STORE = "https://#{CLOUDANT_USER}:#{CLOUDANT_PASS}@docondev.cloudant.com/"

class VelocityCouchIO
  def initialize(db_name='devspect')
    @db_name = db_name
    @end_point = "#{COUCH_STORE}#{@db_name}/"
  end

  def load
    vel = {}
    @db = CouchRest.database(@end_point)
    vel = @db.view('points/velocity')["rows"]
    vel
  end

  def put(vel)
    doc_id = "velocity-#{vel.keys.last}"
    begin
      doc = @db.get(doc_id)
    rescue
      doc = {"_id" => doc_id, "type" => "velocity", "project" => @db_name}
    end

    doc["date"] = vel.keys.last.split("-").map(&:to_i)
    doc["points"] = vel.values.last
    @db.save_doc(doc)
  end

end
