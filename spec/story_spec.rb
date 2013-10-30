require 'story'
require 'json'

describe Story do
  describe '#initialize', :focus => true do
    context "story no person hash" do
      before(:all) do
        story_hash = JSON.parse(File.read("features/support/one_story_data.json"))
        @story_item = story_hash[0]
        @story = Story.new(@story_item)
      end

      it "transforms name" do
        @story.name.should == "Harvester harvests project data from a json file"
      end

      it "transforms current_state to status" do
        @story.status.should == @story_item["current_state"]
      end

      it "transforms updated_at to updated" do
        @story.updated.should == @story_item["updated_at"]
      end

      it "transforms story_type to type" do
        @story.type.should == @story_item["story_type"]
      end

      it "transforms created_at to created" do
        @story.created.should == @story_item["created_at"]
      end

      it "transforms estimate to size" do
        @story.size.should == @story_item["estimate"].to_s
      end

      it "transforms url" do
        @story.url.should == @story_item["url"]
      end

    end

    context "story and person hash" do
      before(:all) do
        people_hash = JSON.parse(File.read('features/support/person_data.json'))
        story_hash = JSON.parse(File.read("features/support/one_story_data.json"))
        @story_item = story_hash[0]
        @story = Story.new(@story_item, people_hash)
      end

      it "transforms requested_by_id to a creator name" do
        @story.creator.should == "Galen Marek"
      end

      it "transforms a missing owned_by_id to a blank owner name" do
        @story.owner.should == "Galen Marek"
      end
    end
  end
end
