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

    context 'with json that is not empty' do
      let(:populated_file) { File.read("features/support/tracker_data.json")}
      let(:populated_hash) { JSON.parse(populated_file)}
      let(:populated_transform) { Transformer.transform(populated_hash)}
      let(:first_story) { populated_transform[0] }

      it 'has a story count greater than 0' do
        populated_transform.story_count.should > 0 
      end

      it 'contains a story' do
        populated_transform[0].should be_kind_of(Story)
      end

      context 'and has the required fields' do
        it 'name' do
          first_story.name.should_not be_empty
        end

        it 'status' do
          first_story.status.should_not be_empty
        end

        it 'updated date' do
          first_story.updated_date.should_not be_empty
          first_story.updated.should be_kind_of(Fixnum)
        end

        it 'created date' do
          first_story.created_date.should_not be_empty
          first_story.created.should be_kind_of(Fixnum)
        end

        it 'type' do
          first_story.type.should_not be_empty
        end

        it 'creator' do
          first_story.creator.should_not be_empty
        end

        it 'size' do
          first_story.size.should_not be_empty
        end
      end
    end

  end

end
