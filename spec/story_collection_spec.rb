require 'story_collection'
require 'story'
require 'json'

describe StoryCollection do

  describe "accepts a story", :focus => true do
    describe '#<<' do
      it "allows a story to be appended to the collection" do
        stories = StoryCollection.new
        stories << Story.new
      end
    end

    describe 'to_json' do
      let(:empty_collection) { StoryCollection.new }
      context "Empty Collection" do
        it "returns a string" do
          empty_collection.to_json.should be_kind_of(String)
        end

        it "returns a valid json string" do
          lambda { JSON.parse(empty_collection.to_json) }.should_not raise_error
        end
      end
      context "One Story Collection" do
        let(:one_story_collection) do
          stories = StoryCollection.new
          stories << Story.new
          stories
        end

        let(:one_story_result) do
          JSON.parse(one_story_collection.to_json)
        end

        it "returns a length of 1" do
          one_story_result.count.should == 1
        end

        describe "has the correct values" do
          it "has the correct name" do
            p one_story_result[0]
            one_story_result[0]["name"].should == "BAD_NAME"
          end
        end

      end
    end
  end
end
