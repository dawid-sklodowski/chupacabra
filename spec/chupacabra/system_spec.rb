require 'spec_helper'

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

    it 'stores once provided password' do
      described_class.get_password
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

  describe 'uninstall' do
    before do
      Chupacabra::System.install
    end

    it 'deletes service directory' do
      Chupacabra::System.user_service_path.should be_exist
      Chupacabra::System.uninstall
      Chupacabra::System.user_service_path.should_not be_exist
    end
  end

  describe 'user_service_path' do
    it 'is correct' do
      Chupacabra::System.user_service_path.should == Pathname.new(ENV['HOME']) + 'Library/Services/Chupacabra_test.workflow'
    end
  end
end