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

    it 'raises error when wrong password' do
      encrypted = Chupacabra::Crypto.encrypt('This is test', 'good password')
      expect{
        Chupacabra::Crypto.decrypt(encrypted, 'wrong password')
      }.to raise_error(Chupacabra::Crypto::WrongPassword)
    end

    it 'shows list of ciphers' do
      puts OpenSSL::Cipher.ciphers
    end
  end
end