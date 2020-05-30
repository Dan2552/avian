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
    def create_texture(*args); shared_instance.create_texture(*args); end
    def set_sprite_texture(*args); shared_instance.set_sprite_texture(*args); end
    def create_text(*args); shared_instance.create_text(*args); end
    def set_text_attributes(*args); shared_instance.set_text_attributes(*args); end
    def camera(*args); shared_instance.camera(*args); end
    def set_sprite_position(*args); shared_instance.set_sprite_position(*args); end
    def set_sprite_rotation(*args); shared_instance.set_sprite_rotation(*args); end
    def set_sprite_flipped(*args); shared_instance.set_sprite_flipped(*args); end
    def set_sprite_visible(*args); shared_instance.set_sprite_visible(*args); end
    def set_sprite_color_blend(*args); shared_instance.set_sprite_color_blend(*args); end
    def remove_sprite(*args); shared_instance.remove_sprite(*args); end
    def set_sprite_scale(*args); shared_instance.set_sprite_scale(*args); end
    def screen_size(*args); shared_instance.screen_size(*args); end
    def width_of_text(*args); shared_instance.width_of_text(*args); end
    def set_camera_position(*args); shared_instance.set_camera_position(*args); end
    def set_camera_scale(*args); shared_instance.set_camera_scale(*args); end
    def delay(*args); shared_instance.delay(*args); end
    def resource_path(*args); shared_instance.resource_path(*args); end
  end

  attr_accessor :window

  def delay(time)
    sleep(time)
  end

  def resource_path(resource = "")
    File.join("resources", resource)
  end

  # Create a sprite to be stored in the renderer's sprite pool.
  #
  def create_sprite(texture, anchor_point)
    sprite = window.add_sprite(texture)
    sprite.tap { |s| s.anchor_point = anchor_point }
  end

  def set_sprite_color_blend(sprite, color, blend_factor)
    sprite.color = color
    sprite.color_blend_factor = blend_factor
  end

  def create_texture(texture_name)
    ::Gosu::Image.new("resources/#{texture_name}.png", tileable: true)
  rescue
    raise "Failed to load texture: resources/#{texture_name}.png"
  end

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

  def width_of_text(renderable, text)
    Gosu::Font
      .new((renderable.font_size) + 8, { name: renderable.font_name })
      .text_width(text)
  end

  def set_text_attributes(node, text, font_size, font_color, x, y, alignment)
    node.text = text
    node.font_size = font_size
    node.font_color = 0xff_000000 + font_color #FONT_COLORS[font_color]
    node.x = x
    node.y = y
    node.alignment = alignment
  end

  def camera
    window.camera
  end

  def set_sprite_position(sprite, position, z_position)
    return if sprite == nil

    # I'm not sure why the Avian::Platforms::Gosu::Camera position needs
    # to be scaled, but it caused all kinds of inconsistencies with iOS in
    # regards to touch locations relative to the camera scale.
    # if sprite.is_a? Avian::DesktopGosuPlatform::Camera
    #   sprite.x = position.x * sprite.scale
    #   sprite.y = position.y * sprite.scale
    # else
      sprite.x = position.x
      sprite.y = position.y
      sprite.z = z_position if z_position
    # end
  end

  def set_sprite_rotation(sprite, vector)
    return if sprite == nil
    sprite.angle = 180 - ::Gosu.angle(0, 0, vector.x, vector.y)
  end

  def set_sprite_flipped(sprite, vertically, horizontally)
    sprite.flipped_vertically = vertically
    sprite.flipped_horizontally = horizontally
  end

  def remove_sprite(sprite)
    window.sprites.delete(sprite)
  end

  def set_sprite_scale(sprite, x_scale, y_scale)
    sprite.x_scale = x_scale
    sprite.y_scale = y_scale
  end

  def screen_size
    @screen_size ||= Size[window.width, window.height]
  end

  def set_camera_position(position)
    camera.x = position.x * camera.scale
    camera.y = position.y * camera.scale
  end

  def set_camera_scale(x_scale, y_scale)
    camera.scale = 1.0 / y_scale
  end
end
