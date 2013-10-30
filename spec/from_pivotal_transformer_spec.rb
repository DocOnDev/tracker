require 'from_pivotal_transformer'
require 'json'
require 'story_collection'

describe FromPivotalTransformer, :focus => true do

  let(:empty_hash) { JSON.parse("[]") }
  let(:empty_transform) { FromPivotalTransformer.transform() }

  describe "#transform" do
    it 'accepts a parameter hash' do
      stories = FromPivotalTransformer.transform({:stories => empty_hash})
    end

    it 'returns a story collection' do
      empty_transform.should be_kind_of(StoryCollection)
    end

    it 'has a story count of 0 if the json is empty' do
      empty_transform.story_count.should == 0
    end

    context 'with json that is not empty' do
      before(:all) do
        people_hash = JSON.parse(File.read('features/support/person_data.json'))
        story_hash = JSON.parse(File.read("features/support/one_story_data.json"))

        @stories = FromPivotalTransformer.transform({:stories=>story_hash,:people=>people_hash})
        @first_story = @stories[0]
      end

      it 'has a story count greater than 0' do
        @stories.story_count.should > 0
      end

      it 'contains a story' do
        @first_story.should be_kind_of(Story)
      end

      context 'has the required fields' do
        describe 'name' do
          it 'is not empty' do
            @first_story.name.should_not be_empty
          end
        end

        describe 'status' do
          it 'is not empty' do
            @first_story.status.should_not be_empty
          end
        end

        describe 'updated' do
          it 'is a number' do
            @first_story.updated.should be_kind_of(Fixnum)
          end
        end

        describe 'updated date' do
          it 'is not empty' do
            @first_story.updated_date.should_not be_empty
          end

          it 'is a string' do
            @first_story.updated_date.should be_kind_of(String)
          end

          it 'is formatted as date/time' do
            @first_story.updated_date.should == "09/22/2013 19:45:32"
          end
        end

        describe 'created' do
          it 'is a number' do
            @first_story.created.should be_kind_of(Fixnum)
          end
        end

        describe 'created date' do
          it 'is not empty' do
            @first_story.created_date.should_not be_empty
          end

          it 'is a string' do
            @first_story.created_date.should be_kind_of(String)
          end

          it 'is formatted as date/time' do
            @first_story.created_date.should == "09/21/2013 21:22:40"
          end
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
        describe 'url' do
          it 'is not empty' do
            @first_story.url.should_not be_empty
          end
        end

        describe 'owner' do
          it 'is not empty' do
            @first_story.owner.should_not be_empty
          end

          it 'is a string' do
            @first_story.owner.should be_kind_of(String)
          end
        end
      end
    end

  end

end
