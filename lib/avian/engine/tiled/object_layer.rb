module Avian
  module Tiled
    class ObjectLayer
      def initialize(hash)
        @hash = hash
      end

      def object_layer?
        true
      end

      def tile_layer?
        false
      end

      # - blk: |object|
      #
      def each_object(&blk)
        # An object in the hash looks like:
        # {
        #   "height"=>0,
        #   "id"=>3,
        #   "name"=>"",
        #   "rotation"=>0,
        #   "type"=>"PLAYER",
        #   "visible"=>true,
        #   "width"=>0,
        #   "x"=>335.876349945507,
        #   "y"=>176.359853363717
        # }
        @hash["objects"].each.with_index do |object|
          blk.call(Object.new(object))
        end
      end

      # * draworder
      # * id
      # * name
      # * objects
      # * opacity
      # * type
      # * visible
      # * x
      # * y
      def [](key)
        @hash[key]
      end
    end
  end
end
