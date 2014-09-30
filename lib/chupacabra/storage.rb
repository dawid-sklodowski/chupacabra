require 'pathname'
require 'fileutils'
require 'json'

module Chupacabra
  class Storage

    class Error < Chupacabra::Error; end

    def self.path
      path = if Chupacabra.test?
        Chupacabra.root + 'tmp' + '.chupacabra'
      else
        Pathname.new(ENV['HOME']) + '.chupacabra'
      end
      raise Error, 'Chupacabra path cant be a file' if path.file?
      path.mkpath unless path.exist?
      path
    end

    def self.passwords_path
      path + 'pw'
    end

    def self.clear
      FileUtils.rm_rf(path)
    end

    def self.version_path
      path + 'version'
    end

    def initialize(password)
      @password = password
    end

    def [](key)
      data[key]
    end

    def []=(key, value)
      data[key] = value
      save
    end

    def to_h
      data
    end

    private

    def data
      @data ||=
      if File.exists?(self.class.passwords_path)
        JSON.parse(Crypto.decrypt(File.read(self.class.passwords_path), @password))
      else
        { }
      end
    end

    def save
      File.open(self.class.passwords_path, 'w') do |file|
        file <<  Crypto.encrypt(@data.to_json, @password)
      end
    end
  end
end
