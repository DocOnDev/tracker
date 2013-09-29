class Writer
  def initialize out_file
    @out_file = out_file
  end

  def write
    File.open(@out_file, "w") { |file| file.write("This is the new file") }
  end
end
