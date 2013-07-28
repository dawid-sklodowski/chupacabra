require 'spec_helper'
require 'digest'

describe Chupacabra::System do

  let(:password) { "asd\" '," }

  before do
    pending 'Works on MacOS only' unless Chupacabra::System.osx?
    described_class.stub(:ask_for_password =>  "text returned:#{password}, button returned:OK\n")
  end

  describe '.get password' do
    subject { described_class.get_password }

    it 'returns password' do
      subject.should == password
    end

    it 'stores once provided password as SHA1' do
      described_class.get_password
      described_class.stub(:ask_for_password =>  "Something different")
      subject.should == Digest::SHA1.hexdigest(password)
    end
  end

  describe 'clipboard operations' do
    it 'saves and loads from clipboard' do
      described_class.set_clipboard('testing clipboard')
      described_class.get_clipboard.should == 'testing clipboard'
    end
  end
end