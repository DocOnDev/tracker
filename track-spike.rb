load 'lib/trackstats.rb'

def report_stories(stories, label)
    p "There are " + stories.count.to_s + " " + label + " stories worth " + stories.points.to_s + " points."
end

def hit_live
    trackstats = TrackStats.new
    report_stories(trackstats.state(:accepted).label(:heartx), "Accepted")
    report_stories(trackstats.state(:delivered).label(:heartx), "Delivered")
    report_stories(trackstats.state(:finished).label(:heartx), "Finished")
    report_stories(trackstats.state(:started).label(:heartx), "Started")
    report_stories(trackstats.state(:unstarted).label(:heartx), "Backlog")
end
