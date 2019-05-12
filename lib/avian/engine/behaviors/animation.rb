class Animation < Behavior
  # - parameter default_texture: The image that should be used when not
  #   animating
  # - parameter texture_names: Array of texture names
  # - parameter time_per_prame: e.g. 0.12
  #
  def initialize(game_object, default_texture, texture_names, time_per_frame)
    @game_object = game_object
    @default_texture = default_texture
    @texture_names = texture_names
    @time_per_frame = time_per_frame
    reset
  end

  def when(condition)
    if condition
      update
      game_object.sprite_name = key_frame
    else
      reset
      game_object.sprite_name = default_texture
    end
  end

  private

  attr_reader :game_object
  attr_reader :default_texture
  attr_reader :time_per_frame
  attr_reader :texture_names
  attr_accessor :key_frame_index
  attr_accessor :time

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
