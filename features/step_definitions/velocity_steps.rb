PROJECT_PATH       = File.join(File.dirname(__FILE__), "../..")
VEL_DATA           = "#{PROJECT_PATH}/lib/velocity_data.rb"
VEL_FILE           = "#{PROJECT_PATH}/lib/velocity_fileio.rb"
require "#{VEL_DATA}"
require "#{VEL_FILE}"

Before do
  @velocity = VelocityData.new(VelocityFileIO.new('velocity_sample.json'))
  reader = TrackerReader.new

  @strs = Array.new(4)
  @strs[0] = PivotalTracker::Story.new(:owned_by => "Bob", :labels => "pwa,heartX", :current_state => "accepted", :story_type => "Feature", :estimate => 1)
  @strs[1] = PivotalTracker::Story.new(:owned_by => "Tom", :labels => nil, :current_state => "accepted", :story_type => "Feature", :estimate => 1)
  @strs[2] = PivotalTracker::Story.new(:owned_by => "Doc", :labels => "heartX", :current_state => "accepted", :story_type => "Feature", :estimate => 1)
  @strs[3] = PivotalTracker::Story.new(:owned_by => "Doc", :labels => "heartX", :current_state => "started", :story_type => "Feature", :estimate => 1)

  prj = mock(PivotalTracker::Project)
  prj.stub_chain(:stories, :all).and_return(@strs)
  prj.stub_chain(:id).and_return(52897)
  reader.project = prj

  iter = mock(PivotalTracker::Iteration)
  iter.stub_chain(:current, :stories).and_return(@strs[0..3])

  prior_iter = mock(PivotalTracker::Iteration)
  prior_iter.stub(:stories).and_return([@strs[2]])
  iter.stub_chain("done").and_return([prior_iter])
  reader.iteration = iter

  @velocity.reader = reader
end

Given /^no label specified$/ do
    @velocity.update_current_velocity
end

Then /^the velocity includes all stories$/ do
    @velocity[Date.today.to_s][:points].should be > 2
end

Given /^the label "(.*?)" is specified$/ do |label|
  @velocity.update_current_velocity :for => label
end

Then /^the velocity includes only "(.*?)" stories$/ do |label|
  vel = @strs.select{|story| story.current_state == "accepted" && story.labels && (story.labels.include? label)}
  @velocity[Date.today.to_s][:points].should == vel.map(&:estimate).inject(:+)
end

Given /^the labels "(.*?)" and "(.*?)" are specified$/ do |label1, label2|
  @velocity.update_current_velocity :for => [label1, label2]
end

Then /^the velocity includes both "(.*?)" and "(.*?)" stories$/ do |label1, label2|
  vel = @strs.select{|story| story.current_state == "accepted" && story.labels && ((story.labels.include? label1 ) || (story.labels.include? label2))}
  @velocity[Date.today.to_s][:points].should == vel.map(&:estimate).inject(:+)
end

Given /^a bogus file$/ do
  @velocity = VelocityData.new(VelocityFileIO.new('bogus_file.json'))
end

Given /^a valid sample file$/ do
  @velocity = VelocityData.new(VelocityFileIO.new('velocity_sample.json'))
end

Then /^there are (\d+) velocity records$/ do |records|
  @velocity.record_count.should == records.to_i
end


