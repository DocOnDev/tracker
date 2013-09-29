require 'to_cloudant_transformer'

class Writer
  def initialize out_file, transformer=ToCloudantTransformer.new
    @out_file = out_file
    @transformer = transformer
  end

  def write collection = {}
    @transformer.transform collection
    File.open(@out_file, "a") { |file| file.write(collection.to_json) }
  end
end
