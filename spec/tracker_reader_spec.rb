require 'chronic'
require 'tracker_reader'

describe TrackerReader do
  let(:reader) { TrackerReader.new }

  before(:each) do
    strs = Array.new(4)
    strs[0] = PivotalTracker::Story.new(:owned_by => "Bob", :labels => "pwa,heartX", :current_state => "accepted", :story_type => "Feature", :estimate => 5)
    strs[1] = PivotalTracker::Story.new(:owned_by => "Tom", :labels => nil, :current_state => "finished", :story_type => "Bug", :estimate => 3)
    strs[2] = PivotalTracker::Story.new(:owned_by => "Doc", :labels => "heartX", :current_state => "finished", :story_type => "Feature", :estimate => 3)
    strs[3] = PivotalTracker::Story.new(:owned_by => "Doc", :labels => "blocked", :current_state => "unstarted", :story_type => "Release", :estimate => 3)

    prj = mock(PivotalTracker::Project)
    prj.stub_chain(:stories, :all).and_return(strs)
    prj.stub_chain(:id).and_return(52897)
    reader.project = prj

    iter = mock(PivotalTracker::Iteration)
    iter.stub_chain(:current, :stories).and_return(strs[0..1])
    iter.stub_chain(:current, :start).and_return(Chronic.parse('last monday'))

    prior_iter = mock(PivotalTracker::Iteration)
    prior_iter.stub(:stories).and_return([strs[2]])
    prior_iter.stub(:start).and_return(Chronic.parse('last monday'))
    iter.stub_chain("done").and_return([prior_iter])
    reader.iteration = iter
  end

  context 'not filtering' do
    it 'returns all stories by default' do
      reader.count.should == 4
    end
  end

  context 'filtering by state' do
    it 'can filter for a specific state' do
      reader.state(:accepted).count.should == 1
    end

    it 'can filter for other specific states' do
      reader.state(:finished).count.should == 2
    end

    it 'can filter for multiple states' do
      reader.state([:accepted, :backlog]).count.should == 2
    end

    it 'can filter for wip (started, finished, or delivered)' do
      reader.state(:wip).count.should == 2
    end
  end

  context 'filtering by label' do
    it 'can filter for a specific label' do
      reader.label(:heartX).count.should == 2
    end

    it 'can filter for multiple labels' do
      reader.label([:heartX, :blocked]).count.should == 3
    end
  end

  context 'filtering by type' do
    it 'can filter for a specific type' do
      reader.type(:feature).count.should == 2
    end

    it 'can filter for multiple types' do
      reader.type([:feature, :bug]).count.should == 3
    end
  end

  context 'filtering on multiple criterion' do
    it 'can filter on two criterion' do
      reader.type(:feature).label(:heartx).count.should == 2
    end

    it 'can filter on three criterion' do
      reader.type(:feature).label(:heartx).state(:accepted).count.should == 1
    end

    it 'does not allow call stacking' do
      reader.label(:heartx).count.should == 2
      reader.state(:finished).count.should == 2
    end
  end

  context 'totals points' do
    it 'counts points for filtered stories' do
      reader.type(:feature).label(:heartX).points.should ==8
    end

    it 'counts points for all the stories' do
      reader.points.should == 14
    end
  end

  context 'filters by owner' do
    it 'returns stories owned by a specific person' do
      reader.owner("Bob").count.should == 1
    end
  end

  context 'filtering by iteration' do
    it 'can filter for current iteration' do
      reader.iteration(:current).count.should == 2
    end
    it 'can filter for prior iteration' do
      reader.iteration(:prior).count.should == 1
    end
  end

  context 'iteration dates' do
    it 'can get the start date for current iteration' do
      reader.iteration(:current).start_date.should == Chronic.parse('last monday')
    end

    #it 'can get the end date for the current iteration' do
      #reader.iteration(:current).end_date.should == Chronic.parse('next sunday')
    #end
  end

  context 'calculates velocity' do
    it 'calculates velocity for a prior iteration' do
      reader.iteration(:prior).velocity.should == 0
    end

    it 'calculates velocity for the current iteration' do
      reader.iteration(:current).velocity.should == 5
    end

    it 'reports 0 velocity for stories not accepted' do
      reader.state(:wip).iteration(:current).velocity.should == 0
    end

    it 'calculates velocity for the entire project' do
      reader.velocity.should == 5
    end
  end

end
