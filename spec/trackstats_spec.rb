require 'trackstats'

describe 'TrackStats' do
    let(:trackstats) { TrackStats.new }

    context 'for a defined set of stories' do
        before(:each) do
            fake_stories = Array.new(4)
            fake_stories[0] = PivotalTracker::Story.new(:current_state => :accepted)
            fake_stories[1] = PivotalTracker::Story.new(:current_state => :finished)
            fake_stories[2] = PivotalTracker::Story.new(:current_state => :finished)
            fake_stories[3] = PivotalTracker::Story.new(:current_state => :unstarted)
            trackstats.stories = fake_stories
        end

        it 'returns all stories' do
            trackstats.stories(:all).count.should == 4
        end

        it 'returns accepted stories' do
            trackstats.stories(:accepted).count.should == 1
        end

        it 'returns finished stories' do
            trackstats.stories(:finished).count.should == 2
        end
    end
end
