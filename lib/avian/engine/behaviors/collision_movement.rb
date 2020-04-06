# Movement, restricted by collisions.
#
# For non-collision movement see `PositionalMovement`.
#
class CollisionMovement < Behavior
  def initialize(game_object)
    @game_object = game_object

    require_respond_to(game_object, :position)
    require_respond_to(game_object, :movement_speed)
  end

  def towards(target)
    current_position = game_object.position
    maximum_step = game_object.movement_speed

    # get vector for ideal movement
    movement_vector = Math::Vector.move_towards(current_position, target, maximum_step)
    # => V[2, 1]

    comparison = Collision::Comparison.frame(game_object.size)
    shortened = Collision.reduce_vector(current_position, movement_vector, &comparison)
    # => V[2, 0]

    game_object.position += shortened
  end

  private

  attr_reader :game_object
end
