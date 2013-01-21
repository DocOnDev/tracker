require 'cfd_data'
require 'cfd_fileio'
require 'cfd_couchio'

# Read data from source
# Daily - Record total points and count for each state
# Write data to source

describe CFDData do
  describe 'supports dependency injection' do
    it 'uses the injected reader' do
      cfd_file = CFDFileIO.new('junk.json')
      cfd = CFDData.new(cfd_file)
      reader = TrackerReader.new
      cfd.reader = reader
      reader.should_receive(:state).at_least(2).times.and_return(reader)
      cfd.add_daily_record
    end
  end

  context 'working with local file' do
    let(:cfd) {CFDData.new(CFDFileIO.new('sample.json'))}

    describe 'read data from file' do
      context 'missing file' do
        it 'should have 0 records' do
          cfd = CFDData.new(CFDFileIO.new('bogus_file.json'))
          cfd.record_count.should == 0
        end
      end

      context 'populated data file' do
        it 'should read 4 records from sample file' do
          cfd.record_count.should == 4
        end
      end
    end

    describe 'append data from tracker' do
      it 'should record total points and count for today' do
        cfd.add_daily_record
        cfd.record_count.should == 5
        cfd[Date.today.to_s][:rejected].should_not be_nil
      end
    end

    describe 'write data to file' do
      it 'should write to a new file' do
        cfd.add_daily_record
        cfd.write('temp.json')
        temp_cfd = CFDData.new(CFDFileIO.new('temp.json'))
        temp_cfd.record_count.should == 5
      end
    end
  end

  context 'working with couch' do
    let(:cfd) {CFDData.new(CFDCouchIO.new('devspect'))}

    describe 'read data from couch' do
      context 'populated database' do
        it 'should read more than one record', :focus => true do
          cfd.record_count.should be > 1
        end
      end
    end

    describe 'write data to couch' do
      it 'should write a new record', :focus => true do
        starting_count = cfd.record_count
        cfd.add_daily_record
        cfd.write
        cfd2 = CFDData.new(CFDCouchIO.new('devspect'))
        cfd2.record_count.should == starting_count + 1
      end
    end

  end
end
