require 'cfd_data'

# Read data from external file
# Daily - Record total points and count for each state
# Write data to external file

describe CFDData do
  describe 'read data from file' do
    context 'missing file' do
      it 'should have 0 records' do
        cfd = CFDData.new('bogus_file.json')
        cfd.record_count.should == 0
      end
    end

    context 'populated data file' do
      it 'should read 4 records from sample file' do
        cfd = CFDData.new('sample.json')
        cfd.record_count.should == 4
      end
    end
  end

  describe 'append data from tracker' do
    it 'should record total points and count for today' do
      cfd = CFDData.new('sample.json')
      cfd.add_daily_record
      cfd.record_count.should == 5
      cfd[Date.today.to_s][:rejected].should_not be_nil
    end
  end

  describe 'write data to file' do
    context 'write to a new file' do
      cfd = CFDData.new('sample.json')
      cfd.add_daily_record
      cfd.write('temp.json')
      temp_cfd = CFDData.new('temp.json')
      temp_cfd.record_count.should == 5
    end
  end
end
