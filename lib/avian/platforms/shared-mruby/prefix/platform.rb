# Platform should abstract away anything that the shared code needs to
# call upon in order to keep things loosely coupled.
#
# This class should be specifically written for each platform.
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

    attr_accessor :render_store
    attr_accessor :camera
  end

  def initialize
    @bridge = Avian::CBridge.new
  end

  def delay(time)
    @bridge.delay(time)
  end

  def resource_path(resource = "")
    File.join("game_resources", resource)
  end

  # Create a sprite to be stored in the renderer's sprite pool.
  #
  def create_sprite(texture, anchor_point)
    sprite = PlatformSprite.new(texture, anchor_point)
    Platform.render_store.sprites << sprite

    sprite
  end

  def create_texture(texture_name)
    @bridge.create_texture(Platform.resource_path("#{texture_name}.png"))
  end

  def set_sprite_texture(sprite, texture)
    sprite.texture = texture
  end

  def set_camera_position(position)
    Platform.camera.x = position.x
    Platform.camera.y = position.y

# TODO:
    # # I'm not sure why the Avian::Platforms::Gosu::Camera position needs
    # # to be scaled, but it caused all kinds of inconsistencies with iOS in
    # # regards to touch locations relative to the camera scale.
    # if sprite.is_a? Avian::DesktopGosuPlatform::Camera
    #   sprite.x = position.x * sprite.scale
    #   sprite.y = position.y * sprite.scale
    # else
    #   sprite.x = position.x
    #   sprite.y = position.y
    #   sprite.z = z_position if z_position
    # end
  end

  def set_camera_scale(x_scale, y_scale)
    # if sprite.is_a?(Avian::DesktopGosuPlatform::Camera)
    #   sprite.scale = 1.0 / y_scale
    # else
    # Platform.camera.x_scale = x_scale
    # Platform.camera.y_scale = y_scale
    Platform.camera.x_scale = 1.0 / x_scale
    Platform.camera.y_scale = 1.0 / x_scale
  end

  def set_sprite_position(sprite, position, z_position)
    # return if sprite == nil

    sprite.x = position.x
    sprite.y = position.y
    sprite.z = z_position if z_position
  end

  def set_sprite_rotation(sprite, vector)
    puts "unimplemented!!! set_sprite_rotation(sprite, vector)"
    # return if sprite == nil
    # sprite.angle = 180 - ::Gosu.angle(0, 0, vector.x, vector.y)
  end

  def set_sprite_flipped(sprite, vertically, horizontally)
    puts "unimplemented!!! set_sprite_flipped(sprite, vertically, horizontally)"
    # sprite.flipped_vertically = vertically
    # sprite.flipped_horizontally = horizontally
  end

  def remove_sprite(sprite)
    Platform.render_store.sprites.delete(sprite)
  end

  def set_sprite_visible(sprite, visible)
    sprite.visible = visible
  end

  def set_sprite_scale(sprite, x_scale, y_scale)
    sprite.x_scale = x_scale
    sprite.y_scale = y_scale
  end

  def set_sprite_color_blend(sprite, color, blend_factor)
    sprite.color = color
    sprite.color_blend_factor = blend_factor
  end

  def screen_size
    @screen_size ||= Size[@bridge.get_screen_width, @bridge.get_screen_height]
  end

  def create_text(font_name)
    text = PlatformText.new(font_name)
    Platform.render_store.texts << text
    text
  end

  def set_text_attributes(node, text, font_size, font_color, x, y, alignment)
    node.text = text
    node.font_size = font_size
    node.font_color = 0xff_000000 + font_color
    node.x = x
    node.y = y
    node.alignment = alignment
  end

  def width_of_text(renderable, text)
    w = @bridge.width_of_text(text, renderable.font_size)
    w * 0.5
  end
end
