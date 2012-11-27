require 'trackstats'

describe TrackStats do
    let(:trackstats) { TrackStats.new }

    before(:each) do
        strs = Array.new(4)
        strs[0] = PivotalTracker::Story.new(:labels => "heartX", :current_state => "accepted")
        strs[1] = PivotalTracker::Story.new(:current_state => "finished")
        strs[2] = PivotalTracker::Story.new(:labels => "heartX", :current_state => "finished")
        strs[3] = PivotalTracker::Story.new(:current_state => "unstarted")

        prj = mock(PivotalTracker::Project)
        prj.stub_chain(:stories, :all).and_return(strs)
        trackstats.project = prj
    end

    context 'not filtering' do
        it 'returns all stories by default' do
            trackstats.count.should == 4
        end
    end

    context 'filtering by state' do
        it 'returns all stories for :all' do
            trackstats.state(:all).count.should == 4
        end

        it 'can filter for a specific state' do
            trackstats.state(:accepted).count.should == 1
        end

        it 'can filter for other specific states' do
            trackstats.state(:finished).count.should == 2
        end

        it 'can filter for multiple states' do
            trackstats.state([:accepted, :unstarted]).count.should == 2
        end
    end
end
