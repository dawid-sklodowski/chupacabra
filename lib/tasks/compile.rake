desc 'Compile AppleScripts'
task :compile do
  require 'chupacabra'
  Chupacabra::System::Scripts.compile_all
end