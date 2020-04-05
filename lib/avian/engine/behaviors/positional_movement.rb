# Moves a game object at it's movement speed towards a given position.
#
class PositionalMovement < Behavior
  def initialize(game_object)
    @game_object = game_object

    require_respond_to(game_object, :position)
    require_respond_to(game_object, :position=)
    require_respond_to(game_object, :movement_speed)
  end

  # Move the game object towards the given position.
  #
  # - returns: (boolean) true if the target has been reached.
  #
  def towards(target_position)
    vector = target_position - game_object.position

    return true if vector.zero?

    velocity = vector.normalize * game_object.movement_speed * Time.delta
    potential_position = game_object.position + velocity

    potential_distance = Math::Distance.quick_distance(game_object.position, potential_position)
    distance_to_target = Math::Distance.quick_distance(game_object.position, target_position)

    if potential_distance < distance_to_target
      game_object.position = potential_position
      return false
    else
      game_object.position = target_position
      return true
    end
  end

  private

  attr_accessor :game_object
end
