require 'story_collection'
require 'story'

describe StoryCollection do

  describe "accepts a story" do
    it "allows a story to be appended to the collection" do
      stories = StoryCollection.new
      stories << Story.new
    end
  end
end
