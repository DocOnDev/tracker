require 'story'

class Transformer
  def self.transform story_hash
    collection = StoryCollection.new
    story_hash.each do |_s|
      story = Story.new
      story.name = _s["name"]
      story.status = _s["current_state"]
      story.updated = _s["updated_at"]
      story.type = _s["story_type"]
      story.creator = _s["requested_by_id"].to_s
      story.created = _s["created_at"]
      story.size = _s["estimate"].to_s
      story.url = _s["url"]
      collection << story
    end
    collection
  end
end
