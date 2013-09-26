require 'story'

class Transformer
  def self.transform story_hash
    collection = StoryCollection.new
    story_hash.each do |_s|
      story = Story.new
      # These elements exist on all stories
      story.name = _s["name"]
      story.status = _s["current_state"]
      story.updated = _s["updated_at"]
      story.type = _s["story_type"]
      story.creator = _s["requested_by_id"].to_s
      story.created = _s["created_at"]
      story.size = _s["estimate"].to_s

      # These elements do not exist on all stories
      story.url = _s["url"] ? _s["url"] : ""
      story.owner = _s["owned_by_id"] ? _s["owned_by_id"].to_s : ""
      collection << story
    end
    collection
  end
end
