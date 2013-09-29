require 'reader'

describe Reader do
  describe '#read', :focus => true do
    let(:missing_file) { 'file_not_found.json' }
    let(:person_file) {'features/support/person_data.json'}
    let(:empty_file) { 'features/support/empty.json' }
    let(:bogus_file) {'features/support/bogus_tracker.json'}
    let(:story_file) {'features/support/story_data.json'}

    describe '#initialize' do
      it 'sets a default for story file' do
        reader = Reader.new
        reader.story_file.should == story_file
      end

      it 'sets a default for person file' do
        reader = Reader.new
        reader.person_file.should == person_file
      end

      it 'accepts a hash parameter' do
        lambda {reader = Reader.new({:story_file => missing_file, :person_file => person_file})}.should_not raise_error
      end

      it 'uses the hash to set the story file' do
        reader = Reader.new({:story_file => missing_file})
        reader.story_file.should == missing_file
      end

      it 'uses the hash to set the person file' do
        reader = Reader.new({:person_file => missing_file})
        reader.person_file.should == missing_file
      end
    end

    describe 'story file' do
      it 'raises a file not found error when file does not exist' do
        reader = Reader.new({:story_file => missing_file})
        lambda { reader.read }.should raise_error("No such file or directory - file_not_found.json")
      end

      it 'raises an error when file is empty' do
        reader = Reader.new({:story_file => empty_file})
        lambda { reader.read }.should raise_error("Invalid Story File Format")
      end

      it 'raises an error when file format is not correct' do
        reader = Reader.new({:story_file => bogus_file})
        lambda { reader.read }.should raise_error("Invalid Story File Format")
      end

      it 'should have tracker stories if the file format is correct' do
        reader = Reader.new()
        data = reader.read
        data.story_count > 0
      end

    end

    describe 'person file' do
      it 'raises a file not found error when file does not exist' do
        reader = Reader.new({:person_file => missing_file})
        lambda { reader.read }.should raise_error("No such file or directory - file_not_found.json")
      end

      it 'raises an error when file is empty' do
        reader = Reader.new({:person_file => empty_file})
        lambda { reader.read }.should raise_error("Invalid Person File Format")
      end

      it 'raises an error when file format is not correct' do
        reader = Reader.new({:person_file => bogus_file})
        lambda { reader.read }.should raise_error("Invalid Person File Format")
      end

      it 'should have people if the file format is correct' do
        reader = Reader.new()
        data = reader.read
        p data[0].owner

        data[0].owner.should_not match /\d+/
      end
    end
  end
end
