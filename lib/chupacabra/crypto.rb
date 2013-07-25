require 'openssl'
require 'base64'

module Chupacabra
  PASSWORD_LENGTH = 32

  module Crypto
    def self.encrypt(text, password)
      encrypter = OpenSSL::Cipher::Cipher.new 'AES256'
      encrypter.encrypt
      encrypter.pkcs5_keyivgen password
      Base64.strict_encode64(encrypter.update(text) + encrypter.final)
    end

    def self.decrypt(text, password)
      encrypted = Base64.strict_decode64(text)
      decrypter = OpenSSL::Cipher::Cipher.new 'AES256'
      decrypter.decrypt
      decrypter.pkcs5_keyivgen password
      decrypter.update(encrypted) + decrypter.final
    end

    def self.generate_password
      raise 'Cannot create safe password for len < 4' if PASSWORD_LENGTH < 4
      letters = 'abcdefghijklmnopqrstuwxyz'
      upcase = letters.upcase
      numbers = '1234567890'
      stuff = '!@$%^&#()-_'
      all = [letters, upcase, numbers, stuff].collect{ |collection| collection.split('') }
      output = all.collect { |collection| collection.shuffle.first }
      (PASSWORD_LENGTH - all.length).times { output << all.flatten.shuffle.first }
      output.join
    end
  end
end
