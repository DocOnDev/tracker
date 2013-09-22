class Transformer
  def self.transform story_hash
    collection = StoryCollection.new(story_hash)
  end
end
