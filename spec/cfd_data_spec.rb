require 'cfd_data'

# Read data from external file
# Daily - Record total points and count for each state
# Write data to external file

describe CFDData do
  subject 
    CFDData new(file_name)

  describe 'read data from file' do
    context 'missing file' do
      it 'should have 0 records' do
        let(:file_name) { 'bogus_file.json' }
        its(:count) { should 0}

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
end
