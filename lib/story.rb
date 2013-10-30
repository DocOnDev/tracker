class Story
  DATE_TIME_FORMAT = '%m/%d/%Y %H:%M:%S'
  attr_accessor :name, :status, :updated, :type, :creator, :created, :size, :url, :owner

  def initialize( story_item = nil, person_hash = {})
    return if !story_item
    @name = story_item["name"]
    @status = story_item["current_state"]
    @updated = story_item["updated_at"]
    @type = story_item["story_type"]
    @creator = get_person_name(story_item["requested_by_id"], person_hash)
    @created = story_item["created_at"]
    @size = story_item["estimate"].to_s

    # These elements do not exist on all stories
    @url = story_item["url"] ? story_item["url"] : ""
    @owner = get_person_name(story_item["owned_by_id"], person_hash)
  end

  def get_person_name(owner_id, person_hash)
    person = person_hash.detect { |per| per["id"] == owner_id }

    return "" if not person
    person["person"]["name"]
  end

  def created_date
    DateTime.strptime("#{@created/1000}", "%s").strftime(DATE_TIME_FORMAT)
  end

  def updated_date
    DateTime.strptime("#{@updated/1000}", "%s").strftime(DATE_TIME_FORMAT)
  end
end
