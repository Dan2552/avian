class Animation
  # - parameter default_texture: The image that should be used when not
  #   animating
  # - parameter texture_names: Array of texture names
  # - parameter time_per_prame: e.g. 0.12
  #
  def initialize(default_texture, texture_names, time_per_frame)
    @default_texture = default_texture
    @texture_names = texture_names
    @time_per_frame = time_per_frame.to_f
    reset
  end

  # Set the animation to animate.
  #
  def animate!
    update
    self.value = key_frame
  end

  # Set the animation to idle.
  #
  def idle!
    reset
    self.value = default_texture
  end

  # This can be used to conditionally animate. Can be used for example like:
  #
  # ```
  # walking_animation.when(walking?)
  # ```
  #
  # When the condition is true, the sprite will animate through the animation's
  # sprite. When false, the animation object will reset itself so that the next
  # time the animation is started, it'll be from the first animation frame
  # again.
  #
  # When a game object has multiple animations, only one animation should be
  # applied to the game object at once. Here's an example for a simple
  # top-down sprite:
  #
  # ```
  # walking_up = direction.y > 0
  # walking_down = direction.y < 0
  #
  # walking_x_more_than_y = direction.x.abs > direction.y.abs
  #
  # walking_left = direction.x < 0 && walking_x_more_than_y
  # walking_right = direction.x > 0 && walking_x_more_than_y
  #
  # walk_up_animation.when(walking_up && !walking_x_more_than_y)
  # walk_down_animation.when(walking_down && !walking_x_more_than_y)
  # walk_left_animation.when(walking_left && walking_x_more_than_y)
  # walk_right_animation.when(walking_right && walking_x_more_than_y)
  # ```
  #
  # You may also want to change face a direction, even when not specifically
  # animating. This can be achieved with the idle_to_default_texture_condition
  # argument. By using a non-nil value on the 2nd argument, animation requires
  # a truthy value on both animate_condition and
  # idle_to_default_texture_condition.
  #
  # E.g. To animate upwards, the following example would require both
  # `movement.moving?` and `direction.up?` to be true. But if `movement.moving?`
  # were false and `direction.up?` was true, then the upwards default sprite
  # would be used.
  #
  # ```
  # walk_up_animation.when(movement.moving?, direction.up?)
  # walk_down_animation.when(movement.moving?, direction.down?)
  # walk_left_animation.when(movement.moving?, direction.left?)
  # walk_right_animation.when(movement.moving?, direction.right?)
  # ```
  #
  # def when(animate_condition, idle_to_default_texture_condition = nil)
  #   using_idle = idle_to_default_texture_condition != nil
  #   if animate_condition && (!using_idle || idle_to_default_texture_condition)
  #     update
  #     game_object.sprite_name = key_frame
  #     self.was_animating = true
  #   else
  #     reset
  #     game_object.sprite_name = default_texture if was_animating || idle_to_default_texture_condition
  #     self.was_animating = false
  #   end
  # end

  private

  attr_reader :default_texture
  attr_reader :time_per_frame
  attr_reader :texture_names
  attr_accessor :key_frame_index
  attr_accessor :time
  attr_accessor :was_animating
  attr_accessor :value

  def update_key_frame
    while time > time_per_frame
      next_frame
      self.time = time - time_per_frame
    end
  end

  def next_frame
    self.key_frame_index = key_frame_index + 1
    if key_frame_index >= texture_names.count - 1
      self.key_frame_index = -1
    end
  end

  def reset
    @time = 0
    @key_frame_index = -1
  end

  def update
    @time += Time.delta
    update_key_frame
  end

  def key_frame
    texture_names[key_frame_index]
  end
end
