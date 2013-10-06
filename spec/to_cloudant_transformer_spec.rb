require 'to_cloudant_transformer'
require 'story_collection'
require 'story'

describe ToCloudantTransformer do
  describe "#transform", :focus => true do
    let(:transformer) { ToCloudantTransformer.new }

    context "empty story collection" do
      let(:empty_story_collection) { StoryCollection.new }
      let(:empty_transform_result) { transformer.transform empty_story_collection }

      it "accepts a story collection" do
        transformer.transform empty_story_collection
      end

      it "returns a hash" do
        empty_transform_result.should be_kind_of(Array)
      end

      it "returns a length of 0" do
        empty_transform_result.count.should be 0
      end
    end
    context "one story collection" do
      let(:one_story_collection) do
        stories = StoryCollection.new
        first_story = Story.new
        first_story.name = "name"
        stories << first_story
      end 
      let(:one_story_transform_result) { transformer.transform one_story_collection }

      it "returns one story back" do
        one_story_transform_result.count.should > 0
      end
      it "returns the correct story name" do
        one_story_transform_result[0]["name"].should be 
      end
    end
  end
end
