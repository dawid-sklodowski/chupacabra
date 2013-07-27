require 'pathname'

module Chupacabra
  class Storage

    def self.filepath
      Pathname.new(ENV['HOME']) + filename
    end

    def self.clear
      filepath.unlink if filepath.exist?
    end

    def initialize(password)
      @password = password
    end

    def [](key)
      data[extract(key)]
    end

    def []=(key, value)
      data[extract(key)] = value
      save
    end

    def to_h
      data
    end

    private

    def self.filename
      Chupacabra.test? ? '.chupacabra_test' : '.chupacabra'
    end

    def data
      @data ||=
      if File.exists?(self.class.filepath)
        Marshal.load(Crypto.decrypt(File.read(self.class.filepath), @password))
      else
        { }
      end
    end

    def save
      File.open(self.class.filepath, 'w') do |file|
        file <<  Crypto.encrypt(Marshal.dump(@data), @password)
      end
    end

    def extract(key)
      if key =~ /https?\:\/\/(?:www.)?([^\/\?]+)/
        $1
      else
        raise ArgumentError, "#{key} doesn't look like url"
      end
    end
  end
end