class Writer
  def initialize out_file
    @out_file = out_file
  end

  def write
    File.open(@out_file, "a") { |file| file.puts("This is some file content.") }
  end
end
