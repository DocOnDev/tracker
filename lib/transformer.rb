#
# receives a ruby object (hash) and transforms into DevSpectStories object
#

class Transformer
  def transform json_data
    raise "No data received" if json_data.length == 0
    raise "Invalid data source"
  end

end
