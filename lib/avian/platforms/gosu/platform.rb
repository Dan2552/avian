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

    def create_sprite(*args); shared_instance.create_rectangle(*args); end
    def create_sprite(*args); shared_instance.create_sprite(*args); end
    def create_sprite(*args); shared_instance.create_sprite(*args); end
    def create_texture(*args); shared_instance.create_texture(*args); end
    def set_sprite_texture(*args); shared_instance.set_sprite_texture(*args); end
    def create_text(*args); shared_instance.create_text(*args); end
    def set_text_attributes(*args); shared_instance.set_text_attributes(*args); end
    def camera(*args); shared_instance.camera(*args); end
    def set_sprite_position(*args); shared_instance.set_sprite_position(*args); end
    def set_sprite_rotation(*args); shared_instance.set_sprite_rotation(*args); end
    def set_sprite_flipped(*args); shared_instance.set_sprite_flipped(*args); end
    def set_sprite_visible(*args); shared_instance.set_sprite_visible(*args); end
    def remove_sprite(*args); shared_instance.remove_sprite(*args); end
    def set_scale(*args); shared_instance.set_scale(*args); end
    def screen_size(*args); shared_instance.screen_size(*args); end
  end

  attr_accessor :window

  def create_rectangle(rectangle)

  end

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
    ::Gosu::Image.new("resources/#{texture_name}.png", tileable: true)
  rescue
    raise "Failed to load texture: resources/#{texture_name}.png"
  end

  # ** Shared **
  #
  def set_sprite_texture(sprite, texture)
    sprite.image = texture
  end

  def set_sprite_visible(sprite, visible)
    sprite.visible = visible
  end

  def create_text(font_name)
    text = Avian::DesktopGosuPlatform::Text.new(font_name)
    text.tap do |t|
      window.texts << text
    end
  end

  # TODO: make it support color hashes instead
  FONT_COLORS = {
    "black" => 0xff_000000,
    "white" => 0xff_ffffff,
  }

  def set_text_attributes(node, text, font_size, font_color, x, y)
    node.text = text
    node.font_size = font_size
    node.font_color = FONT_COLORS[font_color]
    node.x = x
    node.y = y
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
    if sprite.is_a? Avian::DesktopGosuPlatform::Camera
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
