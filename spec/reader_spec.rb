require 'reader'

describe Reader, :focus => true  do
  it "creates a tracker reader by default" do
    Reader.create.should be_kind_of(TrackerReader)
  end
end
