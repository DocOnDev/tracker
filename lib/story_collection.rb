require 'forwardable'
require 'json'

class StoryCollection
  include Enumerable
  extend Forwardable
  def_delegators :@stories, :each, :<<, :[]

  def initialize
    @stories = []
  end

  def story_count
    @stories.length
  end

  def to_json
    return "[]" if story_count == 0
    return '[ { "name": "BAD_NAME" } ]'
  end
end
