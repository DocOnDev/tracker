require 'to_cloudant_transformer'
require 'story_collection'
require 'story'

describe ToCloudantTransformer do
  describe "#transform" do
    let(:transformer) { ToCloudantTransformer.new }

    context "empty story collection" do
      let(:empty_story_collection) { StoryCollection.new }
      let(:empty_transform_result) { transformer.transform empty_story_collection }

      it "accepts a story collection" do
        transformer.transform empty_story_collection
      end

      it "returns the proper type" do
        empty_transform_result.should be_kind_of(Array)
      end

      it "returns a length of 0" do
        empty_transform_result.count.should be 0
      end
    end
    context "one story collection" do
      let(:default_story) do
        story = Story.new
        story.name = "initial name"
        story.status = "ACCEPTED"
        story.url = "http://myurl.com/#"
        story.type = "STORY"
        story
      end
      let(:one_story_collection) do
        stories = StoryCollection.new
        stories << default_story
      end
      let(:one_story_transform_result) { transformer.transform one_story_collection }
      let(:first_result) { one_story_transform_result[0] }

      context "returns the correct" do

        it "story count" do
          one_story_transform_result.count.should > 0
        end

        it "name" do
          first_result["name"].should be default_story.name
        end

        it "status" do
          first_result["status"].should be default_story.status
        end

        it "url" do
          first_result["url"].should be default_story.url
        end

        it "type" do
          first_result["type"].should be default_story.type
        end
      end
    end
  end
end
