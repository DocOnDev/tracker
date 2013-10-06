PROJECT_PATH       = File.join(File.dirname(__FILE__), "../..")
require "#{PROJECT_PATH}/lib/file_reader.rb"
require "#{PROJECT_PATH}/lib/harvester.rb"
require "#{PROJECT_PATH}/lib/writer.rb"

NEW_FILE = 'features/support/new_file.json'
EXISTING_FILE = 'features/support/existing_file.json'


Given /^I have an invalid json file$/ do
    @parse_file = "features/support/bogus_tracker.json"
end

Then /^I receive an error message on parse of file$/ do
  reader = FileReader.new({:story_file => @parse_file})
  harvester = Harvester.new(reader)
  lambda { tracker_data = harvester.retrieve_data }.should raise_error("Invalid File Format")
end

Given /^I have a valid json file with four stories$/ do
    @parse_file = "features/support/story_data.json"
end

Given /^I have a project with four stories$/ do
    parse_file = "features/support/story_data.json"
    reader = FileReader.new({:story_file => @parse_file})
    harvester = Harvester.new(reader)
    tracker_data = harvester.retrieve_data
end

When /^I read that file$/ do
  reader = FileReader.new({:story_file => @parse_file})
  harvester = Harvester.new(reader)
  @tracker_data = harvester.retrieve_data 
end

When /^I write the JSON to the file system$/ do
  remove_file NEW_FILE
  @writer = Writer.new NEW_FILE
  @writer.write
end

Then /^the result should include four elements$/ do
  @tracker_data.story_count.should be 4
end

Then /^the first element should be a story$/ do
  @tracker_data[0].should be_kind_of(Story) 
end

Then /^it should create a new file$/ do
  writer = Writer.new(NEW_FILE)
  writer.write
  File.exist?(NEW_FILE).should == true 
end

Then /^it should be valid JSON$/ do
  @file = File.read(NEW_FILE)
  data = JSON.parse(@file)   
end

Then /^it should have four stories$/ do
  p NEW_FILE
  @file = File.read(NEW_FILE)
  data = JSON.parse(@file)

  data.count.should be 4
end

def remove_file name
  File.delete(name) if File.exist?(name)
end


