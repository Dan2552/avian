require 'active_support/all'
require_relative 'specs/shared_examples/game_object_shared_examples'
require_relative 'specs/expectations'
require_relative 'specs/update_helpers'
require_relative 'specs/platform'

Bundler.require(:default, :development, :spec)

module Avian
  module Specs
    module_function

    def require_all(matcher)
      Dir[File.join(Bundler.root, matcher)].each { |f| require(f) }
    end

    def use_sensible_rspec_defaults(config)
      config.color = true
      config.tty = true
      config.filter_run_when_matching :focus

      config.expect_with :rspec do |expectations|
        expectations.include_chain_clauses_in_custom_matcher_descriptions = true
      end

      config.mock_with :rspec do |mocks|
        mocks.verify_partial_doubles = true
      end

      config.shared_context_metadata_behavior = :apply_to_host_groups
    end
  end
end

if Bundler.rubygems.find_name('avian').first.full_gem_path != Bundler.root.to_s
  Avian::Specs.require_all('lib/**/*.rb')
  Avian::Specs.require_all('app/**/concerns/*.rb')
  Avian::Specs.require_all('app/**/*.rb')
  Avian::Specs.require_all('config/**/*.rb')
end
