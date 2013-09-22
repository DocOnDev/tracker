require 'story'

class Transformer
  def self.transform story_hash
    collection = StoryCollection.new
    story_hash.each do |story|
      collection << Story.new
    end
    collection
  end
end
