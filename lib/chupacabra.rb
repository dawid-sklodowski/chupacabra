require 'fileutils'

module Chupacabra
  extend self

  class Error < StandardError; end

  attr_accessor :env
  attr_accessor :log

  def get_password
    Chupacabra::System.set_clipboard('')
    data = Storage.new(System.get_password)
    key = extract_url(System.get_browser_url) || "app: #{System.front_app}"
    System.log(key)
    if data[key]
      output(data[key])
    else
      data[key] = Crypto.generate_password
      output(data[key])
    end

  rescue Chupacabra::Crypto::WrongPassword
    System.clear
    System.alert('Wrong password!')
    'Wrong password'
  rescue Exception => e
    System.log("Ruby version: #{ RUBY_VERSION }", true)
    System.log("#{ e.class.name }: #{ e.message }\n #{ e.backtrace }", true)
    System.alert("Unexpected error, check log in: #{System.log_path}")
    raise e
  end

  def test?
    env == 'test'
  end

  def root
    Pathname.new(File.expand_path('../..', __FILE__))
  end

  def tmp_dir
    dir = root + 'tmp'
    dir.mkpath unless dir.exist?
    dir
  end

  def clear_tmp
    FileUtils.rm_rf(tmp_dir)
  end

  private

  def output(text)
    if System.osx?
      System.set_clipboard(text)
      System.paste_clipboard unless Chupacabra.test?
    end
    text
  end

  def extract_url(key)
    return unless key
    "web: #{$1}" if key =~ /https?\:\/\/(?:www.)?([^\/\?]+)/
  end
end

require 'chupacabra/system'
require 'chupacabra/system/scripts'
require 'chupacabra/system/install'
require 'chupacabra/crypto'
require 'chupacabra/storage'
require 'chupacabra/version'
require 'pathname'
