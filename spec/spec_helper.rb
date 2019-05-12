require 'avian'
require 'avian/specs'

# Load the spec helpers
#
Avian::Specs.require_all('spec/helpers/**/*.rb')

RSpec.configure do |config|
  Avian::Specs.use_sensible_rspec_defaults(config)
end
