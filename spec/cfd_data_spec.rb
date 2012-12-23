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
  end
end
