require 'chupacabra/system'
require 'chupacabra/crypto'
require 'chupacabra/storage'
require 'chupacabra/version'

module Chupacabra
  extend self
  attr_accessor :env

  def get_password
    data = Storage.new(System.get_password)
    key = System.get_clipboard
    if data[key]
      output(data[key])
    else
      data[key] = Crypto.generate_password
      output(data[key])
    end
  end

  def test?
    env == 'test'
  end

  private

  def output(text)
    System.set_clipboard(text)
    text
  end
end