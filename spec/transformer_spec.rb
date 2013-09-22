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
      before(:all) { @stories = Transformer.transform(JSON.parse(File.read("features/support/tracker_data.json"))) }

      it 'has a story count greater than 0' do
        @stories.story_count.should > 0 
      end

      it 'contains a story' do
        @stories[0].should be_kind_of(Story)
      end

      context 'and has the required fields' do
        before(:all) { @story = @stories[0] }
        it 'name' do
          @story.name.should_not be_empty
        end

        it 'status' do
          @story.status.should_not be_empty
        end

        it 'updated date' do
          @story.updated_date.should_not be_empty
          @story.updated.should be_kind_of(Fixnum)
        end

        it 'created date' do
          @story.created_date.should_not be_empty
          @story.created.should be_kind_of(Fixnum)
        end

        it 'type' do
          @story.type.should_not be_empty
        end

        it 'creator' do
          @story.creator.should_not be_empty
        end

        it 'size' do
          @story.size.should_not be_empty
        end
      end
    end

  end

end
