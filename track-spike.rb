load 'lib/trackstats.rb'

def report_stories(stories, label)
    p "There are " + stories.count.to_s + " " + label + " stories worth " + stories.points.to_s + " points."
end

def hit_live
    trackstats = TrackStats.new
    report_stories(trackstats.label(:heartx), "HeartX")
    report_stories(trackstats.state(:delivered), "Delivered")
    report_stories(trackstats.state(:finished), "Finished")
    report_stories(trackstats.type(:bug).state(:accepted), "accepted")
end
