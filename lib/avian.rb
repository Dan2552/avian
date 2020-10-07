require "avian/version"

AVIAN_LOAD_ORDER = [
  "engine/values/vector.rb",
  "engine/values/**/*.rb",
  "engine/game_objects/internals/attributes.rb",
  "engine/game_objects/internals/*.rb",
  "engine/game_objects/**/*.rb",
  "engine/behaviors/behavior.rb",
  "engine/behaviors/**/*.rb",
  "engine/collision/**/*.rb",
  "engine/math/**/*.rb",
  "engine/text/**/*.rb",
  "engine/rendering/**/*.rb",
  "engine/core/**/*.rb",
  "engine/ui/**/*.rb",
  "engine/application.rb",
  "engine/tiled/object.rb",
  "engine/tiled/tile_layer.rb",
  "engine/tiled/object_layer.rb",
  "engine/tiled/map.rb",
  "engine/algorithms/astar/**/*.rb",
  "engine/algorithms/bresenham_line/**/*.rb",
  "engine/algorithms/theta_star/**/*.rb"
]

AVIAN_GAME_LOAD_ORDER = [
  'lib/**/*.rb',
  'app/values/**/*.rb',
  'app/**/concerns/*.rb',
  'app/**/*.rb',
  'config/**/*.rb'
]

module Avian
  class Error < StandardError; end

  AVIAN_LOAD_ORDER.each do |matcher|
    Dir[File.join(__dir__, "avian", matcher)].each do |f|
      require f
    end
  end
end
