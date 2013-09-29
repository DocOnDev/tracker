require 'writer'

NEW_FILE = 'features/support/new_file.json'
EXISTING_FILE = 'features/support/existing_file.json'

describe Writer, :focus => true do
  it 'should create a new file when the file does not exist' do
    File.delete(NEW_FILE) if File.exist?(NEW_FILE)
    writer = Writer.new(NEW_FILE)
    writer.write
    File.exist?(NEW_FILE).should == true
  end

  it 'should append to a file when the file already exists' do
    start_size = File.size(EXISTING_FILE)
    writer = Writer.new(EXISTING_FILE)
    writer.write
    File.size(EXISTING_FILE).should be > start_size
  end

end
