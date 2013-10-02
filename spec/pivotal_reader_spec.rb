require 'pivotal_reader'

describe PivotalReader, :focus => true do
  OTHER_PROJECT = 70752
  let(:other_project_reader) { PivotalReader.new( {:pivotal_project => OTHER_PROJECT} ) }
  let(:default_reader) { PivotalReader.new }

  describe '#initialize' do
    it 'accepts a hash parameter' do
      lambda { reader = PivotalReader.new( {:pivotal_project => OTHER_PROJECT} ) }.should_not raise_error
    end

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
      reader = PivotalReader.new({:use_ssl => false})
      reader.should_not be_secure
    end
  end

end
