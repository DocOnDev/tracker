require 'trackstats'

describe TrackStats do
  let(:trackstats) { TrackStats.new }

  before(:each) do
    strs = Array.new(4)
    strs[0] = PivotalTracker::Story.new(:owned_by => "Bob", :labels => "pwa,heartX", :current_state => "accepted", :story_type => "Feature", :estimate => 5)
    strs[1] = PivotalTracker::Story.new(:owned_by => "Tom", :labels => nil, :current_state => "finished", :story_type => "Bug", :estimate => 3)
    strs[2] = PivotalTracker::Story.new(:owned_by => "Doc", :labels => "heartX", :current_state => "finished", :story_type => "Feature", :estimate => 3)
    strs[3] = PivotalTracker::Story.new(:owned_by => "Doc", :labels => "blocked", :current_state => "unstarted", :story_type => "Release", :estimate => 3)

    prj = mock(PivotalTracker::Project)
    prj.stub_chain(:stories, :all).and_return(strs)
    prj.stub_chain(:id).and_return(52897)
    trackstats.project = prj

    iter = mock(PivotalTracker::Iteration)
    iter.stub_chain(:current, :stories).and_return(strs[0..1])
    iter.stub_chain("done", :stories).and_return([strs[2]])
    trackstats.iteration = iter
  end

  context 'not filtering' do
    it 'returns all stories by default' do
      trackstats.count.should == 4
    end
  end

  context 'filtering by state' do
    it 'can filter for a specific state' do
      trackstats.state(:accepted).count.should == 1
    end

    it 'can filter for other specific states' do
      trackstats.state(:finished).count.should == 2
    end

    it 'can filter for multiple states' do
      trackstats.state([:accepted, :backlog]).count.should == 2
    end

    it 'can filter for wip (started, finished, or delivered)' do
      trackstats.state(:wip).count.should == 2
    end
  end

  context 'filtering by label' do
    it 'can filter for a specific label' do
      trackstats.label(:heartX).count.should == 2
    end

    it 'can filter for multiple labels' do
      trackstats.label([:heartX, :blocked]).count.should == 3
    end
  end

  context 'filtering by type' do
    it 'can filter for a specific type' do
      trackstats.type(:feature).count.should == 2
    end

    it 'can filter for multiple types' do
      trackstats.type([:feature, :bug]).count.should == 3
    end
  end

  context 'filtering on multiple criterion' do
    it 'can filter on two criterion' do
      trackstats.type(:feature).label(:heartx).count.should == 2
    end

    it 'can filter on three criterion' do
      trackstats.type(:feature).label(:heartx).state(:accepted).count.should == 1
    end

    it 'does not allow call stacking' do
      trackstats.label(:heartx).count.should == 2
      trackstats.state(:finished).count.should == 2
    end
  end

  context 'totals points' do
    it 'counts points for filtered stories' do
      trackstats.type(:feature).label(:heartX).points.should ==8
    end

    it 'counts points for all the stories' do
      trackstats.points.should == 14
    end
  end

  context 'filters by owner' do
    it 'returns stories owned by a specific person' do
      trackstats.owner("Bob").count.should == 1
    end
  end

  context 'filtering by iteration' do
    it 'can filter for current iteration' do
      trackstats.iteration(:current).count.should == 2
    end
    it 'can filter for prior iteration' do
      trackstats.iteration(:prior).count.should == 1
    end
  end

  context 'calculates velocity' do
    it 'calculates velocity for a prior iteration' do
      trackstats.iteration(:prior).velocity.should == 0
    end

    it 'calculates velocity for the current iteration' do
      trackstats.iteration(:current).velocity.should == 5
    end

    it 'reports 0 velocity for stories not accepted' do
      trackstats.state(:wip).iteration(:current).velocity.should == 0
    end
  end

end
