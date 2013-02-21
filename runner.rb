load 'lib/tracker_reader.rb'
load 'lib/cfd_data.rb'
load 'lib/cfd_couchio.rb'
load 'lib/velocity_data.rb'

def report_stories(stories, label)
  p "#{label}: #{stories.count} / #{stories.points}"
end

def run_stats
  p "===================================="
  p "CFD data for #{Time.new.localtime}"
  p "===================================="
  p "Pretty Face"
  hit_live 727223, nil, ["Doc Norton", "Jeff Morgan", "Joel Byler", "Steve Jackson", "Ben Woznicki"]
  save_data "pretty_face", nil
  p "===================================="
  p "DevSpect"
  hit_live 707539, nil, ["Doc Norton"]
  save_data "devspect", nil
  p "===================================="
  p "Personalize/HeartX"
  hit_live 52897, ["heartx", "my profile", "personal_collections"], ["Kofi Appiah", "Dan Gilbert", "Jeff Long", "Kevin Tao"]
  save_data "personalization", ["heartx", "my profile", "personal_collections"]
  p "===================================="
  p "Personalize"
  hit_live 52897, nil, ["Kofi Appiah", "Dan Gilbert", "Jeff Long", "Kevin Tao"]
  save_data "personalize", nil
  p "===================================="
  p "Pull"
  hit_live 614999, nil, ["Darby Frey", "Ruslan Gilfanov", "Ben Haley", "Ryan Kinderman", "Sean Massa", "Keith Norman", "Ben Reinhart", "Sean White"]
  save_data "pull", nil
  p "===================================="
  p "Pull/I-Tier"
  hit_live 614999, ["i-tier"], ["Ben Haley", "Ryan Kinderman", "Sean Massa", "Keith Norman", "Ben Reinhart"]
  save_data "pull_itier", ["i-tier"]
  p "===================================="
  p "Breadcrumb"
  hit_live 567623, nil, ["Bogdan Filioreanu", "Ciprian Tarta", "Jason Crawford", "Bogdan Filioreanu", "Mahmud Din", "Zeke Huang", "Tim Mun", "Ben Bernard", "Andy Andrei Hurjui", "Andrew Miner", "Blake Scholl"]
  save_data "breadcrumb", nil
  p "===================================="
  p "Humor"
  hit_live 578505, nil, ["Ian O'Dea"]
  save_data "humor", nil
  p "===================================="
  p "Reserve"
  hit_live 725097, nil, ["Scott Rogers", "Stephen Johnston", "Dave Kong", "Par Trivedi", "Gerardo Diaz"]
  save_data "reserve", nil
  p "===================================="
  p "Deal Estate"
  hit_live 126097, nil, ["Geoff Massanek", "Eric Meyer", "Dean Marano", "Carl Thuringer", "Sulabh Jain", "Syed Hussain", "Michael Hines", "Lauri Reeves", "Wai Feman", "Vartika Singh"]
  save_data "deal_estate", nil
  p "===================================="
  p "Deal With It"
  hit_live 358255, nil, ["Dave Moore", "Patrick Gombert", "Anthony Caliendo", "Blake Smith"]
  save_data "deal_with_it", nil
  p "===================================="
  p "Local Deal Features"
  hit_live 639881, nil, ["Lucas Willett", "Turner King", "Marcus Sacco", "Richie Vos", "Derrick Spell"]
  save_data "local_deal", nil
  p "===================================="
end


def save_data project_name, labels
  cfd = CFDData.new(CFDCouchIO.new(project_name))
  cfd.reader = @reader
  cfd.add_daily_record :for => labels
  cfd.write
end

def hit_live project_id, label, owners
  @reader = TrackerReader.new
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
  report_stories(@reader.iteration(:current).label(label).type(:chore), "Current Chores")
  owners.each do |owner|
    report_stories(@reader.state(:wip).owner(owner).label(label), owner)
  end
  report_stories(@reader.state(:icebox).label(label), "Icebox")
  report_stories(@reader.state(:wip).label(label), "Total WIP")
  report_stories(@reader.iteration(:current).label(label).state(:accepted), "Current Velocity")
  report_stories(@reader.iteration(:prior).label(label).state(:accepted), "Prior Velocity")
end
