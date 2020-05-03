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
        return nil unless @hash["properties"]
        property = @hash["properties"].find { |hash| hash["name"] == name }
        return nil unless property
        property["value"]
      end
    end
  end
end
