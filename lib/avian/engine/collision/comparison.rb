module Collision
  module Comparison
    def self.frame(size)
      -> (potential_position) do
        potential_rectangle = Rectangle.new(potential_position, size)
        Collision.nearest_objects_to(potential_rectangle).none? do |nearby|
          nearby.frame.intersects?(potential_rectangle)
        end
      end
    end
  end
end
