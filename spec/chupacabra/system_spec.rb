require 'spec_helper'
require 'digest'

describe Chupacabra::System do

  let(:password) { "asd\" '," }

  before do
    pending 'Works on MacOS only' unless Chupacabra::System.osx?
    described_class.stub(:ask_for_password =>  "«class ttxt»:#{password}, «class bhit»:OK\n")
  end

  describe '.get password' do
    subject { described_class.get_password }

    it 'returns password sha1 hash' do
      subject.should == Digest::SHA1.hexdigest(password)
    end

    it 'stores once provided password as SHA1' do
      password = described_class.get_password
      described_class.stub(:ask_for_password =>  "Something different")
      subject.should == password
    end
  end

  describe 'clipboard operations' do
    it 'saves and loads from clipboard' do
      described_class.set_clipboard('testing clipboard')
      described_class.get_clipboard.should == 'testing clipboard'
    end
  end

  describe 'install' do
    after do
      Chupacabra::System.uninstall
    end

    it 'creates service directory' do
      Chupacabra::System.user_service_path.should_not be_exist
      Chupacabra::System.install
      Chupacabra::System.user_service_path.should be_exist
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
end