class Camera < GameObject::Base
  number :scale, default: 2
  attribute :target, type: GameObject::Base

  def initialize
    self.size = Platform.screen_size * scale
  end

  def scale=(set)
    return if set < 1
    @scale = set
    self.size = Platform.screen_size * scale
  end

  # Get the position in a scene from a position relative to the camera.
  #
  # - parameter position: Vector
  # - returns: Vector for the position in the scene
  #
  def screen_position_in_scene(position)
    # If we're zoomed out to scale 2, the screen size is effectively twice as
    # big.
    scaled_touch_position = position * scale
    scaled_touch_position + Vector[frame.left, frame.bottom]
  end

  protected

  # Defines actions that should be performed in the game loop.
  #
  def update
    follow_target!
  end

  private

  def follow_target!
    return if target.nil?
    self.position = target.position
  end
end
