require 'spec_helper'

describe Chupacabra do
  describe '.get_password' do #Rename this method
    before do
      pending 'Works on MacOS only' unless Chupacabra::System.osx?
      Chupacabra::System.stub(:get_password => 'password')
    end

    it 'returns same password for same key' do
      Chupacabra::System.set_clipboard('http://key')
      password1 = Chupacabra.get_password
      Chupacabra::System.set_clipboard('http://key')
      Chupacabra.get_password == password1
    end

    it 'returns different password for different key' do
      Chupacabra::System.set_clipboard('http://key')
      password1 = Chupacabra.get_password
      Chupacabra::System.set_clipboard('http://key2')
      Chupacabra.get_password.should_not == password1
    end

    it 'stores password in clipboard' do
      Chupacabra::System.set_clipboard('http://key')
      password = Chupacabra.get_password
      Chupacabra::System.get_clipboard.should == password
    end
  end
end