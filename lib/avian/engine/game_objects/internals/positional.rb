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
      number :z_position

      # The size of the game object.
      #
      vector :size, default: Size[0, 0]

      # Returns the frame of the object.
      #
      # Assumes the object's position is based on the center of the frame.
      #
      def frame
        raise "#{self} has no size" unless size

        bottom_left = Vector[
          position.x - (size.width / 2.0),
          position.y - (size.height / 2.0)
        ]

        Rectangle.new(bottom_left, size)
      end
    end
  end
end
