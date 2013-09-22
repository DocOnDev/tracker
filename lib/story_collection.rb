class StoryCollection
  def initialize story_hash
    @story_hash = story_hash
  end

  def story_count
    @story_hash.length
  end
end
