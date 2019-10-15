require "avian/version"

AVIAN_LOAD_ORDER = [
  "engine/values/vector.rb",
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
]

module Avian
  class Error < StandardError; end

  AVIAN_LOAD_ORDER.each do |matcher|
    Dir[File.join(__dir__, "avian", matcher)].each do |f|
      require f
    end
  end
end
