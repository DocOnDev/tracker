require 'reader'

describe Reader do
  describe '#read', :focus => true do
    let(:missing_file) { 'file_not_found.json' }
    let(:default_person_file) {'features/support/person_data.json'}
    let(:empty_json_file) { 'features/support/empty.json' }
    let(:bogus_file) {'features/support/bogus_tracker.json'}
    let(:valid_tracker_file) {'features/support/tracker_data.json'}

    describe 'story file' do
      it 'should raise a file not found error when file does not exist' do
        reader = Reader.new(missing_file, default_person_file)
        lambda { reader.read }.should raise_error("No such file or directory - file_not_found.json")
      end

      it 'should raise an error when file is empty' do
        reader = Reader.new(empty_json_file, default_person_file)
        lambda { reader.read }.should raise_error("Invalid Story File Format")
      end

      it 'should raise an error when file format is not correct' do
        reader = Reader.new(bogus_file, default_person_file)
        lambda { reader.read }.should raise_error("Invalid Story File Format")
      end

      it 'should have tracker stories if the file format is correct' do
        reader = Reader.new(valid_tracker_file, default_person_file)
        data = reader.read
        data.story_count > 0
      end

    end

    describe 'person file' do
      it 'should raise a file not found error when file does not exist' do
        reader = Reader.new(valid_tracker_file, missing_file)
        lambda { reader.read }.should raise_error("No such file or directory - file_not_found.json")
      end

      it 'should raise an error when file is empty' do
        reader = Reader.new(valid_tracker_file, empty_json_file)
        lambda { reader.read }.should raise_error("Invalid Person File Format")
      end

      it 'should raise an error when file format is not correct' do
        reader = Reader.new(valid_tracker_file, bogus_file)
        lambda { reader.read }.should raise_error("Invalid Person File Format")
      end

      it 'should have people if the file format is correct' do
        reader = Reader.new(valid_tracker_file, default_person_file)
        data = reader.read
        p data[0].owner

        data[0].owner.should_not match /\d+/
      end
    end
  end
end
