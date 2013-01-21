require 'pivotal-tracker'
require 'yaml'

class TrackerReader
  attr_accessor :configuration

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

  def initialize(params={})
    @configuration = YAML.load_file(params[:configuration] || "config/config.yml")
    project = params[:project] || @configuration[:project][:id]
    PivotalTracker::Client.token = @configuration[:user][:token]
    PivotalTracker::Client.use_ssl = @configuration[:ssl]
    self.project = project
    @label = nil
    @criteria = {}
  end

  def iteration=(iteration)
    @iteration = iteration
  end

  def project=(project)
    if project.is_a?(Integer)
      @project = PivotalTracker::Project.find(project)
    else
      @project = project
    end
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
    if @configuration[:wip] && @configuration[:wip][:include_rejected]
      STATES[:wip] << "rejected" if !STATES[:wip].include? "rejected"
    else
      STATES[:wip].delete("rejected")
    end
    record_criteria(:state, story_state.map{ |state| STATES[state] })
  end

  def type(story_type)
    record_criteria(:type, story_type)
  end

  def label(story_label)
    record_criteria(:label, story_label)
  end

  def iteration(iteration_key)
    record_criteria(:iteration, ITERATIONS[iteration_key])
  end

  private
  def record_criteria(type, value)
    @criteria = {} if @filtered
    @criteria[type] = [value].flatten if value
    @filtered = false
    self
  end

  def should_keep?(filter_criteria, attributes)
    return true if !filter_criteria
    return false if !attributes
    filter_criteria.map!{|fc| fc.downcase.to_s}
    attributes = attributes.downcase.split(",")
    share_an_element?(filter_criteria, attributes)
  end

  def share_an_element?(_a1, _a2)
    (_a1 & _a2).length > 0
  end

  def accepted_possible?
    state_criteria = @criteria[:state]
    return true if (!state_criteria)
    share_an_element?(state_criteria, [STATES[:accepted]].flatten)
  end

  def fetch_iteration_stories(iter_criteria)
      @iteration ||= PivotalTracker::Iteration
      # TODO: create iteration criteria class to improve readability
      #           @iteration.method(iteration_criteria.method_name)
      filter_iter = @iteration.method(iter_criteria[0])
      if iter_criteria[1]
        @stories = filter_iter.call(@project, iter_criteria[1])[0].stories
      else
        @stories = filter_iter.call(@project).stories
      end
  end

  def filter_stories
    if @criteria[:iteration]
      @stories = fetch_iteration_stories(@criteria[:iteration])
    else
      @stories = @project.stories.all
    end
    filtered_stories = @stories.clone
    # TODO: dry this up - make this into an each
    filtered_stories.keep_if{|story| should_keep?(@criteria[:owner], story.owned_by)}
    filtered_stories.keep_if{|story| should_keep?(@criteria[:state], story.current_state)}
    filtered_stories.keep_if{|story| should_keep?(@criteria[:label], story.labels)}
    filtered_stories.keep_if{|story| should_keep?(@criteria[:type], story.story_type)}
    @filtered = true
    filtered_stories
  end
end