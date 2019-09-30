require "avian/version"

module Avian
  class Error < StandardError; end

  [
    "engine/values/**/vector.rb",
    "engine/values/**/*.rb",
    "engine/game_objects/internals/attributes.rb",
    "engine/game_objects/internals/*.rb",
    "engine/game_objects/**/*.rb",
    "engine/behaviors/behavior.rb",
    "engine/behaviors/**/*.rb",
    "engine/math/**/*.rb",
    "engine/rendering/**/*.rb",
    "engine/core/**/*.rb",
    "engine/application.rb"
  ].each do |matcher|
    Dir[File.join(__dir__, "avian", matcher)].each do |f|
      require f
    end
  end
end
