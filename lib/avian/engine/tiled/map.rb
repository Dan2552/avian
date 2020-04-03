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
          @hash["layers"].map do |layer|
            case layer["type"]
            when "tilelayer"
              TileLayer.new(layer)
            when "objectgroup"
              ObjectLayer.new(layer)
            else
              raise "Unexpected layer of type #{layer["type"]}"
            end
          end
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
