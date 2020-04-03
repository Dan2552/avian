module Avian
  module Tiled
    class TileLayer
      def initialize(hash)
        @hash = hash
      end

      def object_layer?
        false
      end

      def tile_layer?
        true
      end

      # - blk: |x, y, tile|
      #
      def each_tile(&blk)
        width = @hash["width"]

        @hash["data"].each.with_index do |tile, index|
          x = index % width
          y = index / width

          blk.call(x, y, tile)
        end
      end

      # * data
      # * height
      # * id
      # * name
      # * opacity
      # * type
      # * visible
      # * width
      # * x
      # * y
      #
      def [](key)
        @hash[key]
      end
    end
  end
end
