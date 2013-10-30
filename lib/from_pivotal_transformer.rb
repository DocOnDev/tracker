require 'story'

class FromPivotalTransformer
  def self.transform options={}
    collection = StoryCollection.new

    story_hash = options[:stories] || {}
    person_hash = options[:people] || {}

    story_hash.each do |story|
      collection << Story.new(story, person_hash)
    end
    collection
  end
end
