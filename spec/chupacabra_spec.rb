require 'spec_helper'

describe Chupacabra do
  describe '.get_password' do #Rename this method
    let(:random_global_password) { Chupacabra::Crypto.generate_password }

    before do
      Chupacabra::System.stub(:get_password => random_global_password)
      Chupacabra::System.stub(:get_browser_url => 'http://www.key')
    end

    it 'returns same password for same key' do
      password = Chupacabra.get_password
      Chupacabra.get_password == password
    end

    it 'returns different password for different key' do
      password = Chupacabra.get_password
      Chupacabra::System.stub(:get_browser_url => 'http://key2')
      Chupacabra.get_password.should_not == password
    end

    it 'stores password in clipboard' do
      pending 'Works on MacOS only' unless Chupacabra::System.osx?
      password = Chupacabra.get_password
      Chupacabra::System.get_clipboard.should == password
    end

    it 'returns same password for http and https urls' do
      password = Chupacabra.get_password
      Chupacabra::System.stub(:get_browser_url => 'https://key')
      Chupacabra.get_password.should == password
    end

    it 'returns same password for domains with or without www' do
      password = Chupacabra.get_password
      Chupacabra::System.stub(:get_browser_url => 'https://key')
      Chupacabra.get_password.should == password
    end

    it 'stores password for application if url not available' do
      Chupacabra::System.stub(:get_browser_url => nil)
      Chupacabra::System.stub(:front_app => 'Chupacabra')
      password = Chupacabra.get_password
      Chupacabra::Storage.new(Chupacabra::System.get_password)['app: Chupacabra'].should == password
    end

    it 'stores password for application if url is invalid' do
      Chupacabra::System.stub(:get_browser_url => 'Bad Url')
      Chupacabra::System.stub(:front_app => 'Chupacabra')
      password = Chupacabra.get_password
      Chupacabra::Storage.new(Chupacabra::System.get_password)['app: Chupacabra'].should == password
    end

    it 'gives alert on wrong password' do
      Chupacabra.get_password
      Chupacabra::System.stub(:get_password => 'wrong password')
      Chupacabra::System.should_receive(:alert)
      Chupacabra.get_password
    end

    it 'clears password system variable on wrong password' do
      Chupacabra.get_password
      Chupacabra::System.stub(:get_password => 'wrong password')
      Chupacabra::System.stub(:alert)
      Chupacabra::System.should_receive(:clear).at_least(1).times
      Chupacabra.get_password
    end
  end
end