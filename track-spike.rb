load 'lib/trackstats.rb'

def report_stories(stories, label)
    p "There are " + stories.length.to_s + " " + label + " stories worth " + stories.reduce(0){|points, story| points + (story.estimate || 0)}.to_s + " points"
end

def hit_live
    trackstats = TrackStats.new
    report_stories(trackstats.stories(:all), "")
    report_stories(trackstats.stories(:started), "started")
    report_stories(trackstats.stories(:delivered), "delivered")
    report_stories(trackstats.stories(:accepted), "accepted")
end
