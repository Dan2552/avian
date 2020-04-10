module Collision
  module Comparison
    def self.frame(size)
      -> (potential_position) do
        bottom_left = Vector[
          potential_position.x - (size.width / 2.0),
          potential_position.y - (size.height / 2.0)
        ]

        potential_rectangle = Rectangle.new(bottom_left, size)
        frame = potential_rectangle

        Collision.nearest_objects_to(potential_rectangle).none? do |nearby|
          nearby.frame.intersects?(potential_rectangle)
        end
      end
    end
  end
end
