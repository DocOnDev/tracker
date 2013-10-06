require 'story_collection'
require 'story'
require 'typhoeus'
require 'json'
require 'from_pivotal_transformer'

class PivotalReader
  DEVSPECT_PROJECT = 707539
  PIVOTAL_ENDPOINT = "https://www.pivotaltracker.com/services/v5/projects/"
  APP_KEY = 'f03476629f1319b3e68d4d0a47011d6f'

  attr_accessor :pivotal_project, :pivotal_key

  def initialize options = {}
    # raise 'Tracker key is Required' if !options[:pivotal_key]
    @pivotal_key = options[:pivotal_key] || APP_KEY
    @pivotal_project = options[:pivotal_project] || DEVSPECT_PROJECT
    @use_ssl = options[:use_ssl].nil? ? true : options[:use_ssl]
  end

  def secure?
    @use_ssl
  end

  def read
    stories = call_pivotal 'stories'
    members = call_pivotal 'memberships'

    FromPivotalTransformer.transform(stories, members)
  end

  private

  def call_pivotal data_type
    request = Typhoeus::Request.new(
        "#{PIVOTAL_ENDPOINT}#{@pivotal_project}/#{data_type}",
        { :headers => {'X-TrackerToken' => @pivotal_key } }
    )

    request.on_complete do | response |
      if response.success?
        data = JSON.parse(response.response_body)
        return data
      elsif response.timed_out?
        raise "Connect to Tracker Timed Out"
      elsif response.code == 0
        raise "Failed to get an HTTP Response from Tracker: #{response.return_message}"
      else
        raise "HTTP Tracker request failed: #{response.code.to_s}"
      end
    end

    request.run
  end
end
