require 'pivotal_reader'

describe PivotalReader, :focus => true do
  describe '#initialize' do
    it 'accepts a hash parameter' do
      lambda { reader = PivotalReader.new( {:pivotal_project => 70752} ) }.should_not raise_error
    end

    it 'sets a default pivotal project' do
      reader = PivotalReader.new
      reader.pivotal_project.should == 707539
    end

    it 'overrides the default pivotal project from hash' do
      reader = PivotalReader.new({:pivotal_project => 70752})
      reader.pivotal_project.should == 70752
    end

    it 'sets use_ssl based on a hash paramter' do
      reader = PivotalReader.new({:use_ssl => false})
      reader.should_not be_secure
    end
  end

end
