require 'transformer'
require 'json'
require 'story_collection'

describe Transformer do

  let(:empty_hash) { JSON.parse("[]") }
  let(:empty_transform) { Transformer.transform(empty_hash) }

  describe "#transform", :focus => true do
   it 'returns a story collection' do
     empty_transform.should be_kind_of(StoryCollection)
   end

   it 'has a story count of 0 if the json is empty' do
     empty_transform.story_count.should == 0
   end

  end

end
