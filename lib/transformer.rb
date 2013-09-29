require 'story'

class Transformer
  def self.transform story_hash, person_hash=Hash.new
    collection = StoryCollection.new
    story_hash.each do |_s|
      story = Story.new
      # These elements exist on all stories
      story.name = _s["name"]
      story.status = _s["current_state"]
      story.updated = _s["updated_at"]
      story.type = _s["story_type"]
      story.creator = get_person_name(_s["requested_by_id"], person_hash)
      story.created = _s["created_at"]
      story.size = _s["estimate"].to_s

      # These elements do not exist on all stories
      story.url = _s["url"] ? _s["url"] : ""
      story.owner = get_person_name(_s["owned_by_id"], person_hash)

      collection << story
    end
    collection
  end

  def self.get_person_name(owner_id, person_hash)
    person = person_hash.detect { |e| e["id"] == owner_id }

    return "" if not person
    person["person"]["name"]
  end
end
