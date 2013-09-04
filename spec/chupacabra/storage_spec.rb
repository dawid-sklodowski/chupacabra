require 'spec_helper'

describe Chupacabra::Storage do

  describe '.path' do
    it { Chupacabra::Storage.path.to_s.should == File.join(Chupacabra.root, 'tmp', '.chupacabra') }
  end

  describe '.passwords_path' do
    it { Chupacabra::Storage.passwords_path.to_s.should == File.join(Chupacabra.root, 'tmp', '.chupacabra', 'pw') }
  end

  describe '.clear' do
    it 'deletes file with data' do
      Chupacabra::Storage.passwords_path.open('w') { |file| file << 'some data' }
      Chupacabra::Storage.passwords_path.should be_exist
      Chupacabra::Storage.clear
      Chupacabra::Storage.passwords_path.should_not be_exist
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
        Chupacabra::Storage.passwords_path.should_not be_exist
        subject['key'] = 'value'
        contents = Chupacabra::Storage.passwords_path.read
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