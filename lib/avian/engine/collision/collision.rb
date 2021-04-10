module Collision
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

  # Deprecated: Tightly couples too much
  #
  # * game_object must respond to `#position`, `#movement_speed`
  # * returns `true` if the object has reached the target
  #
  def self.move_object_towards(game_object, target, collision_grid)
    return true if game_object.position == target

    current_position = game_object.position
    maximum_step = game_object.movement_speed * Time.delta

    # get vector for ideal movement
    movement_vector = Math::Vector.move_towards(current_position, target, maximum_step)
    # => V[2, 1]

    comparison = Collision::Comparison.frame(collision_grid, game_object.size)
    shortened = Collision.reduce_vector(current_position, movement_vector, &comparison)
    # => V[2, 0]

    return true if shortened.zero?

    game_object.position += shortened

    false
  end
end
