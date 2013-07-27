require 'chupacabra/system'
require 'chupacabra/crypto'
require 'chupacabra/storage'

module Chupacabra
  extend self
  attr_accessor :env

  def go
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
    puts text
  end
end