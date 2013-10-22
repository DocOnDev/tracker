require 'reader'

describe Reader, :focus => true  do
  it "creates a tracker reader by default" do
    Reader.create.should be_kind_of(TrackerReader)
  end

  it "creates a file reader when specified" do
    Reader.create(:file).should be_kind_of(FileReader)
  end

  it "throws an error for invalid reader types" do
    lambda{ Reader.create(:foobar) }.should raise_error("Invalid Reader Type Specified")
  end
end
