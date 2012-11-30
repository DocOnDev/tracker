load 'lib/trackstats.rb'

def report_stories(stories, label)
  p label + ": " + stories.count.to_s + " / " + stories.points.to_s
end

def run_stats
  @trackstats = TrackStats.new
  p "Personalize / HeartX"
  hit_live 52897, "heartx", ["Kofi Appiah", "Tristan Blease", "Dan Gilbert", "Jeff Long"]
  p "===================================="
  p "Pull / (all)"
  hit_live 614999, nil, ["Darby Frey", "Ruslan Gilfanov", "Ben Haley", "Ryan Kinderman", "Sean Massa", "Keith Norman", "Ben Reinhart", "Sean White"]
  p "===================================="
  p "Humor"
  hit_live 578505, nil, ["Ian O'Dea"]
  p "===================================="
end

def hit_live project_id, label, owners
  @trackstats.project = project_id
  report_stories(@trackstats.state(:accepted).label(label), "Accepted")
  report_stories(@trackstats.state(:rejected).label(label), "Rejected")
  report_stories(@trackstats.state(:delivered).label(label), "Delivered")
  report_stories(@trackstats.state(:finished).label(label), "Finished")
  report_stories(@trackstats.state(:started).label(label), "Started")
  report_stories(@trackstats.state(:unstarted).label(label), "Backlog")
  report_stories(@trackstats.state(:unscheduled).label(label), "Icebox")
  report_stories(@trackstats.type(:bug).label(label), "Defects")
  report_stories(@trackstats.type(:Chore).label(label), "Chores")

  owners.each do |owner|
    report_stories(@trackstats.state([:started,:finished,:delivered]).owner(owner).label(label), owner)
  end
end
