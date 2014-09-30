# encoding: UTF-8

require 'spec_helper'
require 'digest'

describe Chupacabra::System do

  let(:password) { "asd\" ',a" }
  let(:matched_password) { "asd\" '" }

  before do
    described_class.stub(:ask_for_password =>  "«class ttxt»:#{password}, «class bhit»:OK\n")
  end

  describe '.get password' do
    subject { described_class.get_password }

    it 'returns password sha1 hash' do
      pending 'Works on MacOS only' unless Chupacabra::System.osx?
      subject.should == Digest::SHA1.hexdigest(matched_password)
    end

    it 'stores once provided password as SHA1' do
      pending 'Works on MacOS only' unless Chupacabra::System.osx?
      password = described_class.get_password
      described_class.stub(:ask_for_password =>  "Something different")
      subject.should == password
    end
  end

  describe 'clipboard operations' do
    it 'saves and loads from clipboard' do
      pending 'Works on MacOS only' unless Chupacabra::System.osx?
      described_class.set_clipboard('testing clipboard')
      described_class.get_clipboard.should == 'testing clipboard'
    end
  end

  describe '.execute' do
    it 'returns passed string in test' do
      described_class.execute('Once upon a line').should == 'Once upon a line'
    end

    it 'executes command if true passed as second argument' do
      described_class.execute('echo "Hacky"', true).should == 'Hacky'
    end
  end

  describe '.log' do
    before do
      Chupacabra.log = true
    end

    subject { (Chupacabra::Storage.path + 'chupacabra.log').read.strip }

    it 'logs into file' do
      Chupacabra::System.log('Keep your passwords safe!')
      subject.should == 'Keep your passwords safe!'
    end

    it 'appends to file' do
      Chupacabra::System.log('Line 1')
      Chupacabra::System.log('Line 2')
      subject.should == "Line 1\nLine 2"
    end

    it 'logs when forced even if logging is disabled' do
      Chupacabra.log = false
      Chupacabra::System.log('Forced log line', true)
      subject.should == 'Forced log line'
    end

    it 'does not log when logging disabled' do
      Chupacabra.log = false
      Chupacabra::System.log('I am invisible')
      expect {
        subject
      }.to raise_error(Errno::ENOENT)
    end
  end
end
