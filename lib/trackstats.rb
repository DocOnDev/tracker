require 'pivotal-tracker'

class TrackStats
  USER_TOKEN = '8b2ba20d2a1b4d4309a4868d62f53e7a'
  DEFAULT_PROJECT_ID = 52897

  def initialize
    PivotalTracker::Client.token = USER_TOKEN
    PivotalTracker::Client.use_ssl = true
    @label = nil
    @criteria = {}
  end

  def stories=(stories)
    @stories = stories
  end

  def project=(project)
    @project = project
    @stories = nil
  end

  def points
    filter_stories.inject(0){|sum, story| sum += [0,(story.estimate || 0)].max}
  end

  def count
    filter_stories.count
  end

  def record_criteria(type, value)
    @criteria[type] = [value].flatten
    self
  end

  def state(story_state)
    record_criteria(:state, story_state)
  end

  def type(story_type)
    record_criteria(:type, story_type)
  end

  def label(story_label)
    record_criteria(:label, story_label)
  end

  private
  def filter_matches_attribute?(filter_criteria, attributes)
    return true if !filter_criteria
    return false if !attributes
    filter_criteria.map!{|l_in| l_in.downcase.to_s}
    attributes = attributes.downcase.split(",")
    (filter_criteria & attributes).length > 0
  end

  def filter_stories
    @project ||= PivotalTracker::Project.find(@project_id ||= DEFAULT_PROJECT_ID)
    @stories ||= @project.stories.all
    filtered_stories = @stories.clone
    filtered_stories.keep_if{|story| filter_matches_attribute?(@criteria[:state], story.current_state)}
    filtered_stories.keep_if{|story| filter_matches_attribute?(@criteria[:label], story.labels)}
    filtered_stories.keep_if{|story| filter_matches_attribute?(@criteria[:type], story.story_type)}
    @criteria = {}
    filtered_stories
  end
end
