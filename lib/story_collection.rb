class StoryCollection
  include Enumerable

  def initialize
    @stories = []
  end

  def << (story)
    @stories << story
  end

  def [] (index)
    @stories[index]
  end

  def story_count
    @stories.length
  end
end
