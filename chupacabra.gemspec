# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'chupacabra/version'

Gem::Specification.new do |s|
  s.name        = 'chupacabra'
  s.version     = Chupacabra::VERSION
  s.date        = '2013-07-24'
  s.summary     = "Personal crypto pass"
  s.description = "Encrypted and easy to use personal storage for user passwords"
  s.authors     = ["Dawid Sklodowski"]
  s.email       = 'dawid.sklodowski@gmail.com'
  s.files       = Dir.glob('bin/**/*') +
                  Dir.glob('lib/**/*') +
                  Dir.glob('osx/**/*')
  s.homepage    = 'http://github.com/dawid-sklodowski/chupacabra'
  s.license     = 'MIT'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'coveralls'
  s.executables = ['chupacabra']
  s.post_install_message = <<-EOS
    Thank you for installing chupacabra.

    To hook chupacabra into your MacOS please issue command:

    chupacabra --install
    --------------------

  EOS
end
