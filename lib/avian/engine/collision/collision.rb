module Collision
  # Uses the collision grid to get the objects nearest to a given position.
  #
  # - returns: [Collidable]
  #
  def self.nearest_objects_to(rectangle)
    # call singleton Collision::Grid
    # TODO: calculate depth from size
  end

  # Reduce the given vector if the vector would result in collisions.
  #
  # This can be used for moving game objects towards a direction but preventing
  # them collide with other objects.
  #
  # E.g. if the vector were [2, 1], but there's a wall above, and therefore
  # there should be no upwards movement, the returned value would be [2, 0].
  #
  def self.reduce_vector(current_position, vector, increment = 1, &blk)
    10.times do
      blk.call(potential_position)
    end
  end
end
