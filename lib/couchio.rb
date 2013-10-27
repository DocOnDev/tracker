require 'couchrest'
CLOUDANT_USER = 'docondev' #'shalmordinfrosequeedderb'
CLOUDANT_PASS = 'Agil3cloud' #'nSG4S4nqKYWiSJNSv3n6xM3M'
COUCH_STORE = "https://#{CLOUDANT_USER}:#{CLOUDANT_PASS}@docondev.cloudant.com/"

class CouchIO
  def initialize(db_name='devspect', data_type='cfd')
    @db_name = db_name
    @data_type = data_type
    @end_point = "#{COUCH_STORE}#{@db_name}/"
  end

  def load
    loaded_data = {}
    @db = CouchRest.database(@end_point)
    loaded_data = @db.view("points/#{@data_type}")
    loaded_data
  end

  def put(data)
    doc_id = "#{@data_type}-#{data.keys.last}"
    begin
      doc = @db.get(doc_id)
    rescue
      doc = CouchRest::Document.new("_id" => doc_id, "type" => @data_type, "project" => @db_name)
      @db.save_doc(doc)
      doc = @db.get(doc_id)
    end

    doc["date"] = data.keys.last.split("-").map(&:to_i)
    doc["points"] = data.values.last
    doc.save
  end
end
