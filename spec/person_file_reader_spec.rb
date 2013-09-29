require 'person_file_reader'

class PersonFileReaderSpec
  describe "PersonFileReader", :focus=> true do
    let(:missing_file) { 'file_not_found.json' }
    let(:person_file) {'features/support/person_data.json'}
    let(:empty_file) { 'features/support/empty.json' }
    let(:bogus_file) {'features/support/bogus_tracker.json'}
    let(:story_file) {'features/support/story_data.json'}
    let(:bogus_config_file) {'features/support/bogus.yml'}

    describe "#initialize" do
      it 'accepts a hash parameter' do
        lambda {reader = PersonFileReader.new({:story_file => missing_file, :person_file => person_file})}.should_not raise_error
      end

      it 'sets a default for person file' do
        reader = PersonFileReader.new
        reader.person_file.should == DEFAULT_PERSON_FILE
      end

      it 'uses the hash to set the person file' do
        reader = PersonFileReader.new({:person_file => missing_file})
        reader.person_file.should == missing_file
      end

      it 'gives precedence to specified person file' do
        reader = PersonFileReader.new({:person_file => missing_file})
        reader.person_file.should == missing_file
      end
    end

    describe '#read_data' do
      it 'raises a file not found error when file does not exist' do
        reader = PersonFileReader.new({:person_file => missing_file})
        lambda { reader.read_data }.should raise_error("No such file or directory - file_not_found.json")
      end

      it 'raises an error when file is empty' do
        reader = PersonFileReader.new({:person_file => empty_file})
        lambda { reader.read_data }.should raise_error("Invalid Person File Format")
      end

      it 'raises an error when file format is not correct' do
        reader = PersonFileReader.new({:person_file => bogus_file})
        lambda { reader.read_data }.should raise_error("Invalid Person File Format")
      end
    end
  end
end