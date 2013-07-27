require 'spec_helper'

describe Chupacabra do
  describe '.get_password' do #Rename this method
    before do
      pending 'Works on MacOS only' unless Chupacabra::System.osx?
      Chupacabra::System.stub(:get_password => 'password')
    end

    it 'returns same password for same key' do
      Chupacabra::System.stub(:get_browser_url => 'http://key')
      password = Chupacabra.get_password
      Chupacabra.get_password == password
    end

    it 'returns different password for different key' do
      Chupacabra::System.stub(:get_browser_url => 'http://key')
      password = Chupacabra.get_password
      Chupacabra::System.stub(:get_browser_url => 'http://key2')
      Chupacabra.get_password.should_not == password
    end

    it 'stores password in clipboard' do
      Chupacabra::System.stub(:get_browser_url => 'http://key')
      password = Chupacabra.get_password
      Chupacabra::System.get_clipboard.should == password
    end

    it 'returns same password for http and https urls' do
      Chupacabra::System.stub(:get_browser_url => 'http://key')
      password = Chupacabra.get_password
      Chupacabra::System.stub(:get_browser_url => 'https://key')
      Chupacabra.get_password.should == password
    end

    it 'returns same password for domains with or without www' do
      Chupacabra::System.stub(:get_browser_url => 'http://www.key')
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
  end
end