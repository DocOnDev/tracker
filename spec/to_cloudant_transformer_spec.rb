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
        story_hash = transformer.transform StoryCollection.new

        story_hash.should be_kind_of(Hash)
      end
    end
    context "one story collection" do
      it "returns one story back" do
        transformer = ToCloudantTransformer.new
        stories = StoryCollection.new
        stories << Story.new
        story_hash = transformer.transform stories

        story_hash.count.should > 0
      end
    end
  end
end
