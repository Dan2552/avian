module Collision
  module Comparison
    # Returns a `Proc` that can be used as a block argument to
    # `Collision.reduce_vector`.
    #
    # See `Collision::IncrementalMovement.reduce_vector`.
    #
    def self.frame(collision_grid, size)
      -> (potential_position) do
        bottom_left = Vector[
          potential_position.x - (size.width / 2.0),
          potential_position.y - (size.height / 2.0)
        ]

        potential_rectangle = Rectangle.new(bottom_left, size)
        frame = potential_rectangle

        collision_grid.nearest_objects_to(potential_rectangle).none? do |nearby|
          nearby.frame.intersects?(potential_rectangle)
        end
      end
    end
  end
end
