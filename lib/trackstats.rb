require 'pivotal-tracker'

class TrackStats
    USER_TOKEN = '8b2ba20d2a1b4d4309a4868d62f53e7a'
    DEFAULT_PROJECT_ID = 52897

    def initialize
        @project_id = DEFAULT_PROJECT_ID
        PivotalTracker::Client.token = USER_TOKEN
        PivotalTracker::Client.use_ssl = true
    end

    def stories=(stories)
        @stories = stories
    end

    def project=(project)
        if project.is_a?(PivotalTracker::Project)
            @project = project
        else
            @project_id = project
            @project = nil
        end
        @stories = nil
    end

    def stories(scope)
        get_stories if !@stories
        return @stories if scope == :all
        @stories.find_all{|story| story.current_state == scope}
    end

    private

    def get_stories
        if !@project
            @project_id |= DEFAULT_PROJECT_ID
            @project = PivotalTracker::Project.find(@project_id)
        end
        @stories = @project.stories.all
    end
end
