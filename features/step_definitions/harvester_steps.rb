PROJECT_PATH       = File.join(File.dirname(__FILE__), "../..")
HARVESTER          = "#{PROJECT_PATH}/lib/harvester.rb"
require "#{HARVESTER}"
require 'cucumber/rspec/doubles'

Given(/^I am reading from local text files$/) do
  @config ||= {}
  @config[:source] = {:type => :file}
end

Given(/^I am writing to a local text file$/) do
  @config ||= {}
  @config[:destination] = {:type => :file}
end

When(/^I harvest the data$/) do
  harvester = Harvester.new()
  harvester.harvest(@config)
end

Then(/^I should have (\d+) stories$/) do |arg1|
  pending # express the regexp above with the code you wish you had - touch
end