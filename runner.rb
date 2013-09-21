require 'bundler/setup'
load 'lib/tracker_reader.rb'
load 'lib/cfd_data.rb'
load 'lib/cfd_couchio.rb'
load 'lib/velocity_data.rb'
load 'lib/velocity_couchio.rb'

def report_stories(stories, label)
  p "#{label}: #{stories.count} / #{stories.points}"
end

def load_projects
  project_details = Hash.new
  project_details["Pretty Face"] = {"tracker" => 727223, "labels" => nil, "database" => "pretty_face"}
  project_details["DevSpect"] = {"tracker" => 707539, "labels" => nil, "database" => "devspect"}
  project_details["Gaslight"] = {"tracker" => 52897, "labels" => nil, "database" => "personalize"}
  project_details["HomePage"] = {"tracker" => 906212, "labels" => nil, "database" => "homepage"}
  project_details["MegaMind"] = {"tracker" => 313781, "labels" => nil, "database" => "megamind"}
  project_details["Pull"] = {"tracker" => 614999, "labels" => nil, "database" => "pull"}
  project_details["Breadcrumb"] = {"tracker" => 567623, "labels" => nil, "database" => "breadcrumb"}
  project_details["Humor"] = {"tracker" => 578505, "labels" => nil, "database" => "humor"}
  project_details["Deal Estate"] = {"tracker" => 126097, "labels" => nil, "database" => "deal_estate"}
  project_details["Deal With It"] = {"tracker" => 358255, "labels" => nil, "database" => "deal_with_it"}
  project_details["Deal Wizard"] = {"tracker" => 547815, "labels" => nil, "database" => "deal_wizard"}
  project_details["Quantum Lead"] = {"tracker" => 584807, "labels" => nil, "database" => "quantum_lead"}
  project_details["Coffee"] = {"tracker" => 500037, "labels" => nil, "database" => "coffee"}
  project_details["Optimize Platform"] = {"tracker" => 386283, "labels" => nil, "database" => "optimize_platform"}
  project_details["Communication Engineering"] = {"tracker" => 273627, "labels" => nil, "database" => "comm_eng"}
  project_details
end

def run
  @projects = load_projects
  p "===================================="
  p "CFD data for #{Time.new.localtime}"
  p "===================================="
  run_stats
end


def run_stats
  @projects.select{|k,v| !v["complete"]}.each do |name, project|
    p name
    hit_live project["tracker"], project["labels"]
    save_data project["database"], project["labels"]
    project["complete"] = true
    p "===================================="
  end
end

def save_data project_name, labels
  cfd = CFDData.new(CFDCouchIO.new(project_name))
  cfd.reader = @reader
  cfd.add_daily_record :for => labels
  cfd.write
  vel = VelocityData.new(VelocityCouchIO.new(project_name))
  vel.reader = @reader
  vel.update_current_velocity
  vel.write
end

def hit_live project_id, label
  @reader = TrackerReader.new
  @reader.project = project_id
  report_stories(@reader.state(:accepted).label(label), "Accepted")
  report_stories(@reader.state(:rejected).label(label), "Rejected")
  report_stories(@reader.state(:delivered).label(label), "Delivered")
  report_stories(@reader.state(:finished).label(label), "Finished")
  report_stories(@reader.state(:started).label(label), "Started")
  report_stories(@reader.state(:backlog).label(label), "Backlog")
  report_stories(@reader.iteration(:current).label(label).type(:bug), "Current Defects")
  report_stories(@reader.iteration(:current).label(label).type(:chore), "Current Chores")
  report_stories(@reader.state(:icebox).label(label), "Icebox")
  report_stories(@reader.state(:wip).label(label), "Total WIP")
  report_stories(@reader.iteration(:current).label(label).state(:accepted), "Current Velocity")
  report_stories(@reader.iteration(:prior).label(label).state(:accepted), "Prior Velocity")
end
