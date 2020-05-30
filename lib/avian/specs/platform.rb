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
    def delay(*args); shared_instance.delay(*args); end
  end

  def create_sprite(texture, anchor_point)
  end

  def create_texture(texture_name)
  end

  def set_sprite_texture(sprite, texture)
  end

  def camera
  end

  def set_sprite_position(sprite, position, z_position)
  end

  def set_sprite_rotation(sprite, vector)
  end

  def set_sprite_flipped(sprite, vertically, horizontally)
  end

  def remove_sprite(sprite)
  end

  def set_scale(sprite, scale)
  end

  def screen_size
    @screen_size ||= Size[975, 667]
  end

  def delay(time)
  end
end
