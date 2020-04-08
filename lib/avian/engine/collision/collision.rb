module Collision
  # TODO: spec
  def self.collision_grid
    @collision_grid
  end

  # TODO: spec
  def self.collision_grid=(set)
    @collision_grid = set
  end

  # TODO: spec
  # Uses the collision grid to get the objects nearest to a given position.
  #
  # - returns: [Collidable]
  #
  def self.nearest_objects_to(rectangle, collision_grid = nil)
    collision_grid = self.collision_grid unless collision_grid

    if collision_grid.nil?
      raise "Collision#collision_grid must be setup in the scene."
    end

    collision_grid.nearest_objects_to(rectangle)
  end

  # TODO: spec
  # Reduce the given vector if the vector would result in collisions.
  #
  # This can be used for moving game objects towards a direction but preventing
  # them collide with other objects.
  #
  # E.g. if the vector were [2, 1], but there's a wall above, and therefore
  # there should be no upwards movement, the returned value would be [2, 0].
  #
  def self.reduce_vector(current_position, vector, increment = 1, &blk)
    incremental = Collision::IncrementalMovement.new(current_position, increment)
    incremental.reduce_vector(vector, &blk)
  end
end
