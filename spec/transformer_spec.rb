require 'transformer'
require 'json'
require 'story_collection'

describe Transformer do

  let(:empty_hash) { JSON.parse("[]") }
  let(:empty_transform) { Transformer.transform(empty_hash) }

  let(:populated_file) { File.read("features/support/tracker_data.json")}
  let(:populated_hash) { JSON.parse(populated_file)}
  let(:populated_transform) { Transformer.transform(populated_hash)}

  describe "#transform", :focus => true do
    it 'returns a story collection' do
      empty_transform.should be_kind_of(StoryCollection)
    end

    it 'has a story count of 0 if the json is empty' do
      empty_transform.story_count.should == 0
    end

    it 'has a story count greater than 0 if the json is not empty' do
      populated_transform.story_count.should > 0 
    end

    it 'contains a story if the json is not empty' do
      # populated_transform[0].should be_kind_of(Story)
    end
  end

end
