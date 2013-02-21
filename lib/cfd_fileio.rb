class CFDFileIO
  def initialize(file_name='cfd.json')
    @file_name = file_name
  end

  def load
    cfd = {}
    cfd = JSON.parse(IO.read(@file_name)) if File.exists?(@file_name)
    cfd
  end

  def put(cfd)
    File.open(@file_name,"w") { |f| f.write(cfd.to_json) }
  end
end
