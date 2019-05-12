class Platform
  class << self
    def shared_instance
      @shared_instance ||= new
    end

    def create_sprite(*args); shared_instance.create_sprite(*args); end
    def create_sprite(*args); shared_instance.create_sprite(*args); end
    def create_texture(*args); shared_instance.create_texture(*args); end
    def set_sprite_texture(*args); shared_instance.set_sprite_texture(*args); end
    def camera(*args); shared_instance.camera(*args); end
    def set_sprite_position(*args); shared_instance.set_sprite_position(*args); end
    def set_sprite_rotation(*args); shared_instance.set_sprite_rotation(*args); end
    def set_sprite_flipped(*args); shared_instance.set_sprite_flipped(*args); end
    def remove_sprite(*args); shared_instance.remove_sprite(*args); end
    def set_scale(*args); shared_instance.set_scale(*args); end
    def screen_size(*args); shared_instance.screen_size(*args); end
  end

  # ** Shared **
  #
  def create_sprite(texture, anchor_point)
  end

  # ** Shared **
  #
  def create_texture(texture_name)
  end

  # ** Shared **
  #
  def set_sprite_texture(sprite, texture)
  end

  # ** Shared **
  #
  def camera
  end

  # ** Shared **
  #
  def set_sprite_position(sprite, position, z_position)
  end

  # ** Shared **
  #
  def set_sprite_rotation(sprite, vector)
  end

  def set_sprite_flipped(sprite, vertically, horizontally)
  end

  # ** Shared **
  #
  def remove_sprite(sprite)
  end

  # ** Shared **
  #
  def set_scale(sprite, scale)
  end

  # ** Shared **
  #
  def screen_size
    @screen_size ||= Size[975, 667]
  end
end
