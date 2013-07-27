require 'spec_helper'

describe Chupacabra::Storage do

  describe '.filepath' do
     it { Chupacabra::Storage.filepath.to_s.should == File.join(ENV['HOME'], '.chupacabra_test') }
  end

  describe '.clear' do
    it 'deletes file with data' do
      Chupacabra::Storage.filepath.open('w') { |file| file << 'some data' }
      Chupacabra::Storage.filepath.should be_exist
      Chupacabra::Storage.clear
      Chupacabra::Storage.filepath.should_not be_exist
    end
  end

  describe 'instance methods' do
    subject { Chupacabra::Storage.new('password') }

    describe '#[], #[]=' do
      it 'works like a hash' do
        subject['key'] = 'value'
        subject['key'].should == 'value'
      end

      it 'saves to encrypted file' do
        Chupacabra::Storage.filepath.should_not be_exist
        subject['key'] = 'value'
        contents = Chupacabra::Storage.filepath.read
        contents.length.should > 0
        contents.should_not =~ /value/
        contents.should_not =~ /key/
      end

      it 'saves to file which is loaded by another instance' do
        subject['key'] = 'value'
        Chupacabra::Storage.new('password')['key'].should == 'value'
      end

      it 'cat read contents when initialized with wrong password' do
        subject['key'] = 'value'
        expect {
          Chupacabra::Storage.new('wrong password')['key']
        }.to raise_error(Chupacabra::Crypto::WrongPassword)
      end

      it 'returns nil if no value' do
        subject['key'].should be_nil
      end


    end

    describe '#to_h' do
      it 'returns empty hash when empty' do
        subject.to_h.should == {}
      end

      it 'returns hash with passwords' do
        subject['key'] = 'value'
        subject.to_h.should == {
          'key' => 'value'
        }
      end
    end
  end
end