require 'pathname'

module Chupacabra
  class Storage

    def self.filepath
      if Chupacabra.test?
        Chupacabra.root + filename
      else
        Pathname.new(ENV['HOME']) + filename
      end
    end

    def self.clear
      filepath.unlink if filepath.exist?
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

    def self.filename
      '.chupacabra'
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
  end
end