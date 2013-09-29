class ToCloudantTransformer
  def transform collection
    story_hash = Hash.new
    collection.each do |story|
      story_hash[story.name] = story
    end
    return story_hash
  end
end