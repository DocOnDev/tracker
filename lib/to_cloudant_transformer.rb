class ToCloudantTransformer
  def transform collection
    stories = Array.new
    collection.each do |story|
      story_hash = Hash.new
      story_hash["name"] = story.name
      story_hash["status"] = story.status
      story_hash["url"] = story.url
      story_hash["type"] = story.type
      stories << story_hash
    end
    return stories
  end
end
