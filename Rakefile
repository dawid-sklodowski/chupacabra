require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new('spec')
Dir.glob('lib/tasks/*.rake').each { |task| import task }
task :default => :spec