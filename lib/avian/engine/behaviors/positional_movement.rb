# Moves a game object at it's movement speed towards a given position.
#
class PositionalMovement < Behavior
  def initialize(game_object, speed = nil)
    @game_object = game_object

    require_respond_to(game_object, :position)
    require_respond_to(game_object, :position=)
    require_respond_to(game_object, :movement_speed)

    @speed = speed || @game_object.movement_speed
  end

  # Move the game object towards the given position.
  #
  # - returns: (boolean) true if the target has been reached.
  #
  def towards(target_position)
    return if target_position.nil?

    if game_object.position == target_position
      @moving = false
      return true
    end

    @moving = true

    vector = Math::Vector.move_towards(
      game_object.position,
      target_position,
      speed * Time.delta
    )

    if vector.zero?
      @moving = false
      return true
    end

    game_object.position += vector

    false
  end

  def moving?
    !!@moving
  end

  private

  attr_accessor :game_object
  attr_reader :speed
end
