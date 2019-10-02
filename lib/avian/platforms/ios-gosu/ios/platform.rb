# Platform should abstract away anything that the shared code needs to
# call upon in order to keep things loosely coupled.
#
# This class should be specifically written for each platform.
#
# All methods that should be defined on each platform are labelled
# ** Shared **.
#
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

  attr_accessor :window

  # ** Shared **
  #
  # Create a sprite to be stored in the renderer's sprite pool.
  #
  def create_sprite(texture, anchor_point)
    sprite = window.add_sprite(texture)
    sprite.tap { |s| s.anchor_point = anchor_point }
  end

  # ** Shared **
  #
  def create_texture(texture_name)
    ::Gosu::Image.new("#{texture_name}.png", tileable: true)
  rescue
    raise "Failed to load texture: resources/#{texture_name}.png"
  end

  # ** Shared **
  #
  def set_sprite_texture(sprite, texture)
    sprite.image = texture
  end

  # ** Shared **
  #
  def camera
    window.camera
  end

  # ** Shared **
  #
  def set_sprite_position(sprite, position, z_position)
    return if sprite == nil

    # I'm not sure why the Avian::Platforms::Gosu::Camera position needs
    # to be scaled, but it caused all kinds of inconsistencies with iOS in
    # regards to touch locations relative to the camera scale.
    if sprite.is_a? Avian::IOSGosuPlatform::Camera
      sprite.x = position.x * sprite.scale
      sprite.y = position.y * sprite.scale
    else
      sprite.x = position.x
      sprite.y = position.y
      sprite.z = z_position if z_position
    end
  end

  # ** Shared **
  #
  def set_sprite_rotation(sprite, vector)
    return if sprite == nil
    sprite.angle = 180 - ::Gosu.angle(0, 0, vector.x, vector.y)
  end

  def set_sprite_flipped(sprite, vertically, horizontally)
    sprite.flipped_vertically = vertically
    sprite.flipped_horizontally = horizontally
  end

  # ** Shared **
  #
  def remove_sprite(sprite)
    window.sprites.delete(sprite)
  end

  # ** Shared **
  #
  def set_scale(sprite, scale)
    sprite.scale = 1.0 / scale
  end

  # ** Shared **
  #
  def screen_size
    @screen_size ||= Size[window.width, window.height]
  end
end