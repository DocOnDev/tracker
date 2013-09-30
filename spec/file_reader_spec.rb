require 'file_reader'

describe FileReader do
  let(:missing_file) { 'file_not_found.json' }
  let(:person_file) { 'features/support/person_data.json' }
  let(:empty_file) { 'features/support/empty.json' }
  let(:bogus_file) { 'features/support/bogus_tracker.json' }
  let(:story_file) { 'features/support/story_data.json' }
  let(:bogus_config_file) { 'features/support/bogus.yml' }

  describe '#initialize' do
    it 'accepts a hash parameter' do
      lambda { reader = FileReader.new({ :story_file => missing_file, :person_file => person_file }) }.should_not raise_error
    end
  end

  describe 'story file' do
    it 'should have tracker stories if the file format is correct' do
      reader = FileReader.new()
      data   = reader.read
      data.story_count > 0
    end
  end

  describe 'people file' do
    it 'should have people if the file format is correct' do
      reader = FileReader.new()
      data   = reader.read
      data[0].owner.should_not match /\d+/
    end
  end
end
