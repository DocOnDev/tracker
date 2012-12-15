PROJECT_PATH       = File.join(File.dirname(__FILE__), "../..")
TRACK_STATS        = "#{PROJECT_PATH}/lib/trackstats.rb"
require "#{TRACK_STATS}"
require 'cucumber/rspec/doubles'

Before do
  @ts = TrackStats.new
  strs = Array.new(6)
  strs[0] = PivotalTracker::Story.new(:owned_by => "Bob", :labels => "pwa,heartX", :current_state => "accepted", :story_type => "Feature", :estimate => 5)
  strs[1] = PivotalTracker::Story.new(:owned_by => "Tom", :labels => nil, :current_state => "finished", :story_type => "Bug", :estimate => 3)
  strs[2] = PivotalTracker::Story.new(:owned_by => "Doc", :labels => "heartX", :current_state => "finished", :story_type => "Feature", :estimate => 3)
  strs[3] = PivotalTracker::Story.new(:owned_by => "Doc", :labels => "blocked", :current_state => "unstarted", :story_type => "Release", :estimate => 3)
  strs[4] = PivotalTracker::Story.new(:owned_by => "Doc", :labels => nil, :current_state => "started", :story_type => "Feature", :estimate => 3)
  strs[5] = PivotalTracker::Story.new(:owned_by => "Doc", :labels => "pwa", :current_state => "rejected", :story_type => "Feature", :estimate => 1)

  prj = mock(PivotalTracker::Project)
  prj.stub_chain(:stories, :all).and_return(strs)
  prj.stub_chain(:id).and_return(52897)
  @ts.project = prj

  iter = mock(PivotalTracker::Iteration)
  iter.stub_chain(:current, :stories).and_return(strs[0..1])

  prior_iter = mock(PivotalTracker::Iteration)
  prior_iter.stub(:stories).and_return([strs[2]])
  iter.stub_chain("done").and_return([prior_iter])
  @ts.iteration = iter
end

Given /^no WIP entry in the configuration file$/ do
end

When /^I filter for WIP$/ do
  @ts.state(:wip)
end

Then /^the count should not include rejected stories$/ do
    @ts.count.should == 3
end

Then /^the points should not include rejected stories$/ do
    @ts.points.should == 9
end
