module Avian
  module Tiled
    class Object
      def initialize(hash)
        @hash = hash
      end

      # * height
      # * id
      # * name
      # * rotation
      # * type
      # * visible
      # * width
      # * x
      # * y
      #
      def [](key)
        @hash[key]
      end

      # TODO: spec
      def property(name)
        @hash["properties"].find { |hash| hash["name"] == name }["value"]
      end
    end
  end
end
