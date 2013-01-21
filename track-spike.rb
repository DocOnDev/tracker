load 'lib/tracker_reader.rb'
load 'lib/cfd_data.rb'
load 'lib/cfd_couchio.rb'

def report_stories(stories, label)
  p "#{label}: #{stories.count} / #{stories.points}"
end

def run_stats
  @reader = TrackerReader.new
  p "===================================="
  p "CFD data for #{Time.new.localtime}"
  p "===================================="
  p "DevSpect"
  hit_live 707539, nil, ["Michael Norton"]
  save_data 707539, "devspect"
  p "Personalize"
  hit_live 52897, ["heartx", "my profile", "personal_collections"], ["Kofi Appiah", "Tristan Blease", "Dan Gilbert", "Jeff Long"]
  save_data 52897, "personalize"
  p "===================================="
  p "Pull"
  hit_live 614999, nil, ["Darby Frey", "Ruslan Gilfanov", "Ben Haley", "Ryan Kinderman", "Sean Massa", "Keith Norman", "Ben Reinhart", "Sean White"]
  save_data 614999, "pull"
  p "===================================="
  p "Humor"
  hit_live 578505, nil, ["Ian O'Dea"]
  save_data 578505, "humor"
  p "===================================="
end

def save_data project_id, project_name
  cfd = CFDData.new(CFDCouchIO.new(project_name))
  @reader.project = project_id
  cfd.reader = @reader
  cfd.add_daily_record
  cfd.write
end

def hit_live project_id, label, owners
  @reader.project = project_id
  report_stories(@reader.state(:accepted).label(label), "Accepted")
  report_stories(@reader.state(:rejected).label(label), "Rejected")
  report_stories(@reader.state(:delivered).label(label), "Delivered")
  report_stories(@reader.state(:finished).label(label), "Finished")
  report_stories(@reader.state(:started).label(label), "Started")
  report_stories(@reader.state(:backlog).label(label), "Backlog")
  report_stories(@reader.type(:bug).label(label), "All Defects")
  report_stories(@reader.iteration(:current).label(label).type(:bug), "Current Defects")
  report_stories(@reader.type(:Chore).label(label), "Chores")
  report_stories(@reader.iteration(:current).label(label).type(:Chore), "Current Chores")
  owners.each do |owner|
    report_stories(@reader.state(:wip).owner(owner).label(label), owner)
  end
  report_stories(@reader.state(:icebox).label(label), "Icebox")
  report_stories(@reader.state(:wip).label(label), "Total WIP")
  report_stories(@reader.iteration(:current).label(label).state(:accepted), "Current Velocity")
  report_stories(@reader.iteration(:prior).label(label).state(:accepted), "Prior Velocity")
end
