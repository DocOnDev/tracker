#
# Reads/Writes data to couch data store
# (currently coupled to cloudant)
#
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
    # TODO: Relying on last entry seems pretty brittle
    record_date = data.keys.last
    doc = load_document("#{@data_type}-#{record_date}")
    doc["date"] = record_date.split("-").map(&:to_i)
    doc["points"] = data.values.last
    doc.save
  end

  private

  def load_document(doc_id)
    begin
      doc = @db.get(doc_id)
    rescue
      doc = CouchRest::Document.new("_id" => doc_id, "type" => @data_type, "project" => @db_name)
      @db.save_doc(doc)
      doc = @db.get(doc_id)
    end
    doc
  end

end
