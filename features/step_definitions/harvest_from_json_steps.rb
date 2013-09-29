PROJECT_PATH       = File.join(File.dirname(__FILE__), "../..")
require "#{PROJECT_PATH}/lib/reader.rb"
require "#{PROJECT_PATH}/lib/harvester.rb"

Given /^I have an invalid json file$/ do
    @parse_file = "features/support/bogus_tracker.json"
end

Then /^I receive an error message on parse of file$/ do
  reader = Reader.new({:story_file => @parse_file})
  harvester = Harvester.new(reader)
  lambda { tracker_data = harvester.retrieve_data }.should raise_error("Invalid File Format")
end

Given /^I have a valid json file with four stories$/ do
    @parse_file = "features/support/story_data.json"
end

When /^I read that file$/ do
  reader = Reader.new({:story_file => @parse_file})
  harvester = Harvester.new(reader)
  @tracker_data = harvester.retrieve_data 
end

Then /^the result should include four elements$/ do
  @tracker_data.story_count.should be 4
end

Then /^the first element should be a story$/ do
  @tracker_data[0].should be_kind_of(Story) 
end
