require 'reader'

describe Reader, :focus => true  do
  describe ".create" do
    it "creates tracker reader by default" do
      Reader.create.should be_kind_of(TrackerReader)
    end

    it "creates file reader when specified" do
      Reader.create(:file).should be_kind_of(FileReader)
    end

    it "creates tracker reader when specified" do
      Reader.create(:tracker).should be_kind_of(TrackerReader)
    end

    it "throws error for invalid reader types" do
      lambda{ Reader.create(:foobar) }.should raise_error("Invalid Reader Type Specified")
    end
  end
end
