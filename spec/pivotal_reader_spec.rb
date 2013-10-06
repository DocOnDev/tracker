require 'pivotal_reader'

describe PivotalReader, :focus => true do
  OTHER_PROJECT = 70752
  let(:other_project_reader) { PivotalReader.new( {:pivotal_project => OTHER_PROJECT} ) }
  let(:default_reader) { PivotalReader.new }

  describe '#initialize' do
    context 'sets pivotal project' do
      it 'sets a default pivotal project' do
        default_reader.pivotal_project.should == 707539
      end

      it 'overrides the default pivotal project from hash' do
        other_project_reader.pivotal_project.should == OTHER_PROJECT
      end
    end

    context 'sets a pivotal key' do
      it 'sets a default pivotal key' do
        default_reader.pivotal_key.should == PivotalReader::APP_KEY
      end

      it 'sets pivotal key based on hash parameter' do
        reader = PivotalReader.new({:pivotal_key => '12345'})
        reader.pivotal_key.should == '12345'
      end
    end

    context 'sets a secure connection' do
      it 'defaults to a secure connection' do
        default_reader.should be_secure
      end

      it 'sets secure connection based on a hash parameter' do
        reader = PivotalReader.new({:use_ssl => false})
        reader.should_not be_secure
      end
    end


  end

  describe '#read' do
    context 'returns data' do
      it 'has at least one story' do
        data = default_reader.read
        data.story_count.should > 0
      end

      it 'has owner data' do
        data = default_reader.read
        data[0].owner.should_not match /\d+/
      end
    end
  end
end
