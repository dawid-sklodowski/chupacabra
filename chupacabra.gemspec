Gem::Specification.new do |s|
  s.name        = 'chupacabra'
  s.version     = '0.0.1'
  s.date        = '2013-07-24'
  s.summary     = "Chupacabra"
  s.description = "Personal crypto pass"
  s.authors     = ["Dawid Sklodowski"]
  s.email       = 'dawid.sklodowski@gmail.com'
  s.files       = Dir.glob('bin/**/*') +
                  Dir.glob('lib/**/*')
  s.homepage    = 'http://github.com/dawid-sklodowski/chupacabra'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rake'
  s.executables = ['chupacabra']
end