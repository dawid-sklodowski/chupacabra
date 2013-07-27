require 'chupacabra/system'
require 'chupacabra/crypto'
require 'chupacabra/storage'
require 'chupacabra/version'

module Chupacabra
  extend self
  attr_accessor :env

  def get_password
    data = Storage.new(System.get_password)
    key = extract_url(System.get_browser_url) || "app: #{System.front_app}"
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

  def extract_url(key)
    "web: #{$1}" if key =~ /https?\:\/\/(?:www.)?([^\/\?]+)/
  end
end