require 'cfd_data'

# Read data from external file
# Daily - Record total points and count for each state
# Write data to external file

describe CFDData do
  let(:cfd) {CFDData.new('sample.json')}

  describe 'supports dependency injection' do
    it 'uses the injected reader', :focus => true do
      cfd = CFDData.new('junk.json')
      reader = TrackerReader.new
      cfd.reader = reader
      reader.should_receive(:state).at_least(2).times.and_return(reader)
      cfd.add_daily_record
    end
  end

  describe 'read data from file' do
    context 'missing file' do
      it 'should have 0 records' do
        cfd = CFDData.new('bogus_file.json')
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
      temp_cfd = CFDData.new('temp.json')
      temp_cfd.record_count.should == 5
    end
  end
end
