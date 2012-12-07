require 'pivotal-tracker'

class TrackStats
  USER_TOKEN = '8b2ba20d2a1b4d4309a4868d62f53e7a'
  DEFAULT_PROJECT_ID = 52897

  STATES = {
    :unscheduled => "unscheduled",
    :icebox => "unscheduled",
    :unstarted => "unstarted",
    :backlog => "unstarted",
    :started => "started",
    :finished => "finished",
    :delivered => "delivered",
    :accepted => "accepted",
    :done => "accepted",
    :rejected => "rejected",
    :wip => ["started", "finished", "delivered"]
  }

  ITERATIONS = {
    :backlog => ["backlog", nil],
    :current => ["current",nil],
    :prior => ["done", {:offset => -1}],
    :next => [nil, {:offset => 1, :limit => 1}]
  }

  def initialize(project=DEFAULT_PROJECT_ID)
    PivotalTracker::Client.token = USER_TOKEN
    PivotalTracker::Client.use_ssl = true
    self.project = project
    @label = nil
    @criteria = {}
  end

  def stories=(stories)
    @stories = stories
    @fetched = true
  end

  def iteration=(iteration)
    @iteration = iteration
    @fetched = false
  end

  def project=(project)
    if project.is_a?(Integer)
      @project = PivotalTracker::Project.find(project)
    else
      @project = project
    end
    @fetched = false
  end

  def points
    filter_stories.inject(0){|sum, story| sum += [0,(story.estimate || 0)].max}
  end

  def velocity
    velocity = 0
    if accepted_possible?
      current_criteria = @criteria.clone
      velocity = self.state(:accepted).points
      @criteria = current_criteria
    end
    return velocity
  end

  def count
    filter_stories.count
  end

  def owner(story_owner)
    record_criteria(:owner, story_owner)
  end

  def state(story_state)
    story_state = [story_state].flatten
    record_criteria(:state, story_state.map{ |state| STATES[state] })
  end

  def type(story_type)
    record_criteria(:type, story_type)
  end

  def label(story_label)
    record_criteria(:label, story_label)
  end

  def iteration(iteration_key)
    @iter_criteria = ITERATIONS[iteration_key]
    @fetched = false
    self
  end

  private
  def record_criteria(type, value)
    @criteria = {} if @fetched
    @fetched = false
    @criteria[type] = [value].flatten if value
    self
  end

  def should_keep?(filter_criteria, attributes)
    return true if !filter_criteria
    return false if !attributes
    filter_criteria.map!{|l_in| l_in.downcase.to_s}
    attributes = attributes.downcase.split(",")
    share_an_element?(filter_criteria, attributes)
  end

  def share_an_element?(_a1, _a2)
    (_a1 & _a2).length > 0
  end

  def accepted_possible?
    return true if @fetched
    state_criteria = @criteria[:state]
    return true if (!state_criteria)
    share_an_element?(state_criteria, [STATES[:accepted]].flatten)
  end

  def filter_stories
    if @iter_criteria
      iter = @iteration ||= PivotalTracker::Iteration
      filter_iter = iter.method(@iter_criteria[0])
      if @iter_criteria[1]
        @stories = filter_iter.call(@project, @iter_criteria[1])[0].stories
      else
        @stories = filter_iter.call(@project).stories
      end
    else
      @stories ||= @project.stories.all
    end
    filtered_stories = @stories.clone
    filtered_stories.keep_if{|story| should_keep?(@criteria[:owner], story.owned_by)}
    filtered_stories.keep_if{|story| should_keep?(@criteria[:state], story.current_state)}
    filtered_stories.keep_if{|story| should_keep?(@criteria[:label], story.labels)}
    filtered_stories.keep_if{|story| should_keep?(@criteria[:type], story.story_type)}
    @fetched = true
    filtered_stories
  end
end
