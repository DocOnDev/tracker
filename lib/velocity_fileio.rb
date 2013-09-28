class VelocityFileIO
  def initialize(file_name='velocity.json')
    @story_file_name = file_name
  end

  def load
    cfd = {}
    cfd = JSON.parse(IO.read(@story_file_name)) if File.exists?(@story_file_name)
    cfd
  end

  def put(cfd)
    File.open(file_name,"w") { |f| f.write(cfd.to_json) }
  end
end

