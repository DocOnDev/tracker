require 'pivotal-tracker'
PROJET_ID = 52897
USER_TOKEN = '8b2ba20d2a1b4d4309a4868d62f53e7a'

PivotalTracker::Client.token = USER_TOKEN
PivotalTracker::Client.use_ssl = true
@project = PivotalTracker::Project.find(PROJET_ID)
heartx_stories = @project.stories.all(:label => ['heartx'], :includedone => [true])

def report_stories(stories, label)
    stories = stories.find_all{|story| story.current_state == label}
    p "There are " + stories.length.to_s + " " + label + " stories worth " + stories.reduce(0){|points, story| points + (story.estimate || 0)}.to_s + " points"
end

report_stories(heartx_stories, 'accepted')
report_stories(heartx_stories, 'delivered')
report_stories(heartx_stories, 'finished')
report_stories(heartx_stories, 'started')
report_stories(heartx_stories, 'unstarted')
