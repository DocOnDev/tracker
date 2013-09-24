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
      before(:all) do
        @stories = Transformer.transform(JSON.parse(File.read("features/support/tracker_data.json")))
        @first_story = @stories[0]
      end

      it 'has a story count greater than 0' do
        @stories.story_count.should > 0 
      end

      it 'contains a story' do
        @first_story.should be_kind_of(Story)
      end

      context 'has the required fields' do
        it 'name' do
          @first_story.name.should_not be_empty
        end

        it 'status' do
          @first_story.status.should_not be_empty
        end

        it 'updated date' do
          @first_story.updated_date.should_not be_empty
          @first_story.updated.should be_kind_of(Fixnum)
          @first_story.updated_date.should be_kind_of(String)
          @first_story.updated_date.should == "09/22/2013 19:45:32"
        end

        it 'created date' do
          @first_story.created_date.should_not be_empty
          @first_story.created.should be_kind_of(Fixnum)
          @first_story.created_date.should be_kind_of(String)
          @first_story.created_date.should == "09/21/2013 21:22:40"
        end

        it 'type' do
          @first_story.type.should_not be_empty
        end

        it 'creator' do
          @first_story.creator.should_not be_empty
        end

        it 'size' do
          @first_story.size.should_not be_empty
        end
      end

      context 'has the optional fields' do
        it 'url' do
          @first_story.url.should_not be_empty
        end

        it 'owner' do
          @first_story.owner.should_not be_nil
          @first_story.owner.should_not be_empty
        end
      end
    end

  end

end
