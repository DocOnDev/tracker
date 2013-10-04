require 'pivotal_reader'

describe PivotalReader, :focus => true do
  OTHER_PROJECT = 70752
  let(:other_project_reader) { PivotalReader.new( {:pivotal_key => '123456789', :pivotal_project => OTHER_PROJECT} ) }
  let(:default_reader) { PivotalReader.new( {:pivotal_key => '123456789'} ) }

  describe '#initialize' do
    it 'sets a default pivotal project' do
      default_reader.pivotal_project.should == 707539
    end

    it 'overrides the default pivotal project from hash' do
      other_project_reader.pivotal_project.should == OTHER_PROJECT
    end

    it 'defaults to a secure connection' do
      default_reader.should be_secure
    end

    it 'sets secure connection based on a hash parameter' do
      reader = PivotalReader.new({:pivotal_key => '123456789', :use_ssl => false})
      reader.should_not be_secure
    end

    it 'raises an error when there is no pivotal key' do
      lambda { reader = PivotalReader.new }.should raise_error
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
