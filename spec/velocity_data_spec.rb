require 'bundler/setup'
require 'velocity_data'
require 'velocity_fileio'
#require 'velocity_couchio'

describe VelocityData do
  describe 'supports dependency injection' do
    it 'uses the injected reader' do
      velocity_file = VelocityFileIO.new('junk.json')
      velocity = VelocityData.new(velocity_file)
      reader = TrackerReader.new
      velocity.reader = reader
      reader.should_receive(:state).at_least(2).times.and_return(reader)
      velocity.update_current_velocity
    end
  end

  describe 'supports label filtering' do
    let(:velocity) {VelocityData.new(VelocityFileIO.new('velocity_sample.json'))}
    it 'defaults to no labels', :focus => true do
      velocity.update_current_velocity
      puts velocity[Date.today.to_s]
      velocity[Date.today.to_s][:points].should be > 2
    end

    it 'accepts a single label' do
      velocity.update_current_velocity :for => "testing"
      velocity[Date.today.to_s][:icebox].should == 1
    end

    it 'accepts multiple labels' do
      velocity.update_current_velocity :for => ["testing", "more_testing"]
      velocity[Date.today.to_s][:icebox].should == 2
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
        velocity[Date.today.to_s][:rejected].should_not be_nil
      end
    end

    describe 'write data to file' do
      it 'should write to a new file' do
        velocity.update_current_velocity
        velocity.write('temp.json')
        temp_velocity = VelocityData.new(VelocityFileIO.new('temp.json'))
        temp_velocity.record_count.should == 5
      end
    end
  end

  context 'working with couch' do
    let(:velocity) {VelocityData.new(VelocityCouchIO.new('devspect'))}

    describe 'read data from couch' do
      context 'populated database' do
        it 'should read more than one record' do
          velocity.record_count.should be > 1
        end
      end
    end

    describe 'write data to couch' do
      it 'should write a new record' do
        starting_count = velocity.record_count
        velocity.update_current_velocity
        velocity.write
        velocity2 = VelocityData.new(VelocityCouchIO.new('devspect'))
        velocity2.record_count.should == starting_count + 1
      end
    end

  end
end
