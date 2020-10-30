# Platform should abstract away anything that the shared code needs to
# call upon in order to keep things loosely coupled.
#
# This class should be specifically written for each platform.
#
class Platform
  class << self
    def delay(time)
      bridge.delay(time)
    end

    def draw_frame
      renderer.draw_frame
    end

    def resource_path(resource = "")
      File.join("game_resources", resource)
    end

    def documents_path(resource = "")
      File.join(bridge.documents_path, resource)
    end

    def create_shape(renderable)
      shape = PlatformShape.new(renderable)
      render_store << shape
    end

    def create_sprite(renderable)
      sprite = PlatformSprite.new(renderable)
      render_store << sprite
    end

    def set_sprite_textures(sprite, texture, shadow_texture)
      sprite.texture = texture
      sprite.shadow_texture = shadow_texture
    end

    def create_texture(texture_name)
      bridge.create_texture(resource_path("#{texture_name}.png"))
    end

    def clear_textures
      bridge.clear_textures
    end

    def set_camera_attributes(position, x_scale, y_scale)
      camera.x = position.x
      camera.y = position.y
      camera.x_scale = 1.0 / x_scale
      camera.y_scale = 1.0 / x_scale
    end

    def remove_sprite(sprite)
      render_store.delete(sprite)
    end

    def screen_size
      @screen_size ||= Size[bridge.get_screen_width, bridge.get_screen_height]
    end

    def create_text(renderable)
      text = PlatformText.new(renderable)
      render_store << text
    end

    def width_of_text(font_name, font_size, text)
      w = bridge.width_of_text(text, font_size)
      w * 0.5
    end

    private

    def renderer
      @renderer ||= PlatformRenderer.new(render_store, camera)
    end

    def render_store
      @render_store ||= PlatformRenderStore.new
    end

    def camera
      @camera ||= PlatformCamera.new(
        bridge.get_screen_width,
        bridge.get_screen_height
      )
    end

    def bridge
      @bridge ||= Avian::CBridge.new
    end
  end
end
