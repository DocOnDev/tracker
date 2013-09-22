require 'transformer'
require 'json'
require 'story_collection'

describe Transformer do

  let(:story_hash) { JSON.parse("[]") }

  describe "#transform", :focus => true do
   it 'returns a story collection' do
     Transformer.transform(story_hash).should be_kind_of(StoryCollection)
   end
  end

end
