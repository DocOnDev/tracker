require 'pivotal-tracker'

class TrackStats
    USER_TOKEN = '8b2ba20d2a1b4d4309a4868d62f53e7a'
    DEFAULT_PROJECT_ID = 52897

    def initialize
        PivotalTracker::Client.token = USER_TOKEN
        PivotalTracker::Client.use_ssl = true
        @story_state = :all
    end

    def stories=(stories)
        @stories = stories
    end

    def project=(project)
        @project = project
        @stories = nil
    end
    
    def count
        @project ||= PivotalTracker::Project.find(@project_id ||= DEFAULT_PROJECT_ID)
        filtered_stories = @stories ||= @project.stories.all
        filtered_stories = @stories.find_all{|story| @story_state.to_s.include? story.current_state} unless @story_state == :all
        filtered_stories.count
    end

    def state(story_state)
        # states: unscheduled, unstarted, started, finished, delivered, accepted, or rejected.
        @story_state = story_state
        self
    end
end
