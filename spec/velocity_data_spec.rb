require 'bundler/setup'
require 'chronic'
require 'velocity_data'
require 'velocity_fileio'
require 'velocity_couchio'

describe VelocityData do
  before(:each) do
    if Date.today.strftime("%A") == "Sunday"
      check_date = Date.today
    else
      check_date = Chronic.parse('next sunday')
    end
    @iteration_date = check_date.strftime("%Y-%m-%d")
  end

  describe 'supports dependency injection' do
    it 'uses the injected reader' do
      velocity_file = VelocityFileIO.new('junk.json')
      velocity = VelocityData.new(velocity_file)
      reader = TrackerReader.new
      velocity.reader = reader
      reader.should_receive(:state).at_least(1).times.and_return(reader)
      velocity.update_current_velocity
    end
  end

  context 'working with local file' do
    let(:velocity) {VelocityData.new(VelocityFileIO.new('velocity_sample.json'))}

    describe 'read data from file' do
      context 'missing file' do
        it 'should have 0 records' do
          velocity = VelocityData.new(VelocityFileIO.new('bogus_file.json'))
          velocity.record_count.should == 0
        end
      end

      context 'populated data file' do
        it 'should read 4 records from sample file' do
          velocity.record_count.should == 4
        end
      end
    end

    describe 'append data from tracker' do
      it 'should record total points and count for today' do
        velocity.update_current_velocity
        velocity.record_count.should == 5
        velocity[@iteration_date].should_not be_nil
      end
    end

  end

  context 'working with couch' do
    let(:velocity) {VelocityData.new(CouchIO.new('devspect', 'velocity'))}

    describe 'read data from couch' do
      context 'populated database' do
        it 'should read more than one record' do
          velocity.record_count.should be > 1
        end
      end
    end

    describe 'write data to couch' do
      it 'should write or update a record' do
        starting_count = velocity.record_count
        velocity.update_current_velocity
        velocity.write
        velocity2 = VelocityData.new(CouchIO.new('devspect', 'velocity'))
        velocity2.record_count.should be > 1
      end
    end

  end
end
