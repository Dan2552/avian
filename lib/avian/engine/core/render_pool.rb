class RenderPool
  class << self
    def add(renderable)
      if renderable.is_a?(GameObject::Text)
        find_or_create_text(renderable)
      elsif renderable.is_a?(GameObject::Shape)
        find_or_create_shape(renderable)
      else
        is_new = pool[renderable.id].nil?
        return if renderable.static_renderable && !is_new

        if renderable.shadow_overlay
          shadow_overlay_texture = find_or_create_texture(renderable.shadow_overlay.image)
        end

        sprite = find_or_create_sprite(renderable)

        texture = find_or_create_texture(renderable.sprite_name)
        if renderable.shadow_overlay
          shadow_image = renderable.shadow_overlay.image
          shadow_texture = find_or_create_texture(shadow_image)
        end

        Platform.set_sprite_textures(sprite, texture, shadow_texture)
      end
    end

    def remove(renderable)
      sprite_node = find_or_create_sprite(renderable)
      Platform.remove_sprite(sprite_node)
      pool.delete(renderable.id)
    end

    def reset
      @pool = nil
      @texture_pool = nil
      @text_pool = nil
      @shape_pool = nil
    end

    private

    def pool
      @pool ||= {}
    end

    def texture_pool
      @texture_pool ||= {}
    end

    def text_pool
      @text_pool ||= {}
    end

    def shape_pool
      @shape_pool ||= {}
    end

    def find_or_create_sprite(renderable)
      pool[renderable.id] = (
        pool[renderable.id] || Platform.create_sprite(renderable)
      )
    end

    def find_or_create_texture(texture_name)
      texture_pool[texture_name] = (
        texture_pool[texture_name] || Platform.create_texture(texture_name)
      )
    end

    def find_or_create_text(renderable)
      text_pool[renderable.id] = (
        text_pool[renderable.id] || Platform.create_text(renderable)
      )
    end

    def find_or_create_shape(renderable)
      shape_pool[renderable.id] = (
        shape_pool[renderable.id] || Platform.create_shape(renderable)
      )
    end
  end
end
