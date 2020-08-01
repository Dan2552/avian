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

    def camera(*args); shared_instance.camera(*args); end
    def create_sprite(*args); shared_instance.create_sprite(*args); end
    def create_texture(*args); shared_instance.create_texture(*args); end
    def create_text(*args); shared_instance.create_text(*args); end
    def set_sprite_attributes(*args); shared_instance.set_sprite_attributes(*args); end
    def set_text_attributes(*args); shared_instance.set_text_attributes(*args); end
    def remove_sprite(*args); shared_instance.remove_sprite(*args); end
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


  def set_sprite_attributes(
      sprite,
      texture,
      anchor_point,
      position,
      z_position,
      visible,
      color,
      color_blend_factor,
      x_scale,
      y_scale,
      shadow_overlay_texture,
      shadow_overlay_x,
      shadow_overlay_y
    )

    sprite.texture = texture
    sprite.anchor_point = anchor_point
    sprite.x = position.x
    sprite.y = position.y
    sprite.z = z_position
    sprite.visible = visible
    sprite.color = color
    sprite.color_blend_factor = color_blend_factor
    sprite.x_scale = x_scale
    sprite.y_scale = y_scale
    sprite.shadow_texture = shadow_overlay_texture
    sprite.shadow_x = shadow_overlay_x
    sprite.shadow_y = shadow_overlay_y
  end

  def create_texture(texture_name)
    @bridge.create_texture(Platform.resource_path("#{texture_name}.png"))
  end

  def set_camera_position(position)
    Platform.camera.x = position.x
    Platform.camera.y = position.y
  end

  def set_camera_scale(x_scale, y_scale)
    Platform.camera.x_scale = 1.0 / x_scale
    Platform.camera.y_scale = 1.0 / x_scale
  end

  def remove_sprite(sprite)
    Platform.render_store.sprites.delete(sprite)
  end

  def screen_size
    @screen_size ||= Size[@bridge.get_screen_width, @bridge.get_screen_height]
  end

  def create_text(font_name, anchor_point)
    text = PlatformText.new(font_name, anchor_point)
    Platform.render_store.texts << text
    text
  end

  def set_text_attributes(node, text, font_size, font_color, x, y)
    node.text = text
    node.font_size = font_size
    node.font_color = 0xff_000000 + font_color
    node.x = x
    node.y = y
  end

  def width_of_text(font_name, font_size, text)
    w = @bridge.width_of_text(text, font_size)
    w * 0.5
  end
end
