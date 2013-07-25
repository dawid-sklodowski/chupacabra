require 'spec_helper'

describe Chupacabra::Crypto do
  describe '.generate_password' do
    it 'returns 32 characters password' do
      Chupacabra::Crypto.generate_password.length.should == 32
    end

    it 'returns different password each time' do
      Chupacabra::Crypto.generate_password.should_not == Chupacabra::Crypto.generate_password
    end
  end

  describe 'encrypt & decrypt' do
    it 'encrypts and decrypts given string' do
      encrypted = Chupacabra::Crypto.encrypt('This is test', 'some password')
      decrypted = Chupacabra::Crypto.decrypt(encrypted, 'some password')

      decrypted.should == 'This is test'
      decrypted.should_not == encrypted
    end
  end
end