require 'writer'

describe Writer do
  it 'should create a new file when the file does not exist' do
    File.delete('new_file.json') if File.exist?('new_file.json')
    writer = Writer.new('new_file.json')
    writer.write
    File.exist?('new_file.json').should == true
  end
end
