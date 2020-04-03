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
    end
  end
end
