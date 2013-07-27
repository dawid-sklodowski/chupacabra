require 'chupacabra'
require 'pry'

Chupacabra.env = 'test'

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'
  config.before(:each) { Chupacabra::System.clear; Chupacabra::Storage.clear }
  config.after(:each) { Chupacabra::System.clear; Chupacabra::Storage.clear }
end

