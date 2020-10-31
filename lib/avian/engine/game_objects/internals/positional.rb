module GameObject
  module Internals
    module Positional
      extend GameObject::Internals::Attributes

      # The position of the game object.
      #
      vector :position

      # Rotation of the game object.
      #
      vector :rotation, default: Vector[0,1]

      # The z-position of the game object.
      #
      number :z_position, default: 0

      # The size of the game object.
      #
      vector :size, default: Size[0, 0]

      # Returns the frame of the object.
      #
      def frame
        raise "#{self} has no size" unless size

        bottom_left = Vector[
          position.x - (size.width * renderable_anchor_point.x),
          position.y - (size.height * renderable_anchor_point.y)
        ]

        Rectangle.new(bottom_left, size)
      end
    end
  end
end
