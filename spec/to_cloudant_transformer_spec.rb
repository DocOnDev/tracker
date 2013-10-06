require 'to_cloudant_transformer'
require 'story_collection'
require 'story'

describe ToCloudantTransformer do
  describe "#transform", :focus => true do
    context "empty story collection" do
      it "accepts a story collection" do
        transformer = ToCloudantTransformer.new
        transformer.transform StoryCollection.new
      end

      it "returns a hash" do
        transformer = ToCloudantTransformer.new
        story_array = transformer.transform StoryCollection.new

        story_array.should be_kind_of(Array)
      end
    end
    context "one story collection" do
      
      it "returns one story back" do
        transformer = ToCloudantTransformer.new
        stories = StoryCollection.new
        first_story = Story.new
        first_story.name = "name"

        stories << first_story
        story_array = transformer.transform stories

        story_array.count.should > 0
      end
      it "returns the correct story name" do
        transformer = ToCloudantTransformer.new
        stories = StoryCollection.new
        first_story = Story.new
        first_story.name = "name"

        stories << first_story
        story_array = transformer.transform stories
        story_array[0]["name"].should be 
      end
    end
  end
end
