module Avian
  module Tiled
    class Map
      def initialize(hash)
        @hash = hash
        if @hash["infinite"] == true
          raise "Can't import infinite map. " +
            "Convert the map via Map->Map Properties->Infinite"
        end
      end

      def layers
        @layers ||= begin
          @hash["layers"].map { |layer| Layer.new(layer) }
        end
      end

      # * compressionlevel
      # * height
      # * infinite
      # * layers
      # * nextlayerid
      # * nextobjectid
      # * orientation
      # * renderorder
      # * tiledversion
      # * tileheight
      # * tilesets
      # * tilewidth
      # * type
      # * version
      # * width
      #
      def [](key)
        @hash[key]
      end
    end
  end
end
