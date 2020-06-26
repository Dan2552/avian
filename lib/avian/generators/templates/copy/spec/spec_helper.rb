require 'avian'
require 'avian/specs'

# Load the game (the files we're testing)
#
Avian::Specs.require_game

# Load the spec helpers
#
Avian::Specs.require_all('spec/helpers/**/*.rb')

# Configure RSpec
#
RSpec.configure do |config|
  Avian::Specs.use_sensible_rspec_defaults(config)
end
