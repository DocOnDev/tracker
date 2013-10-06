require 'to_cloudant_transformer'
require 'story_collection'
require 'story'

describe ToCloudantTransformer do
  describe "#transform", :focus => true do
    let(:transformer) { ToCloudantTransformer.new }

    context "empty story collection" do
      let(:empty_story_collection) { StoryCollection.new }
      
      it "accepts a story collection" do
        transformer.transform empty_story_collection
      end

      it "returns a hash" do
        story_array = transformer.transform empty_story_collection
        story_array.should be_kind_of(Array)
      end

      it "returns a length of 0" do
        story_array = transformer.transform empty_story_collection
        story_array.count.should be 0
      end
    end
    context "one story collection" do
      
      it "returns one story back" do
        stories = StoryCollection.new
        first_story = Story.new
        first_story.name = "name"

        stories << first_story
        story_array = transformer.transform stories

        story_array.count.should > 0
      end
      it "returns the correct story name" do
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
