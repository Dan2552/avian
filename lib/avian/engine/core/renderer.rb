# Responsible for rendering the game graph's objects on screen.
#
class Renderer
  def self.set_root(root)
    @root = root
    @instance = nil
  end

  def self.instance
    @instance ||= Renderer.new(@root)
  end

  # parameter root: The root GameObject instance.
  #
  def initialize(root)
    @root = root
  end

  def camera_updated
    Platform.set_camera_position(camera_game_object.position)
    Platform.set_camera_scale(camera_game_object.scale, camera_game_object.scale)
  end

  # Draws a frame on the screen. The Loop should call this once per frame after
  # running through the logic.
  #
  # def draw_frame
    # Profiler.shared_instance.start_of("Renderer")
    # Platform.set_camera_position(camera_game_object.position)
    # Platform.set_camera_scale(camera_game_object.scale, camera_game_object.scale)
    # traverse
    # Profiler.shared_instance.end_of("Renderer")
  # end

  # private

  attr_reader :root

  # def traverse
  #   RenderList.shared_instance.each do |game_object|
  #     draw(game_object)
  #   end
  # end

  def remove(renderable)
    sprite_node = find_or_create_sprite(renderable)
    Platform.remove_sprite(sprite_node)
    pool.delete(renderable.id)
  end

  def draw(renderable)
    return draw_text(renderable) if renderable.is_a?(GameObject::Text)

    is_new = pool[renderable.id].nil?
    return if renderable.static_renderable && !is_new

    sprite_node = find_or_create_sprite(renderable)

    shadow_overlay_texture = nil
    if renderable.shadow_overlay
      shadow_overlay_texture = find_or_create_texture(renderable.shadow_overlay.image)
    end

    Platform.set_sprite_attributes(
      sprite_node,
      find_or_create_texture(renderable.sprite_name),
      renderable.renderable_anchor_point,
      renderable.position,
      renderable.z_position,
      renderable.visible,
      renderable.color,
      renderable.color_blend_factor,
      renderable.x_scale,
      renderable.y_scale,
      shadow_overlay_texture,
      renderable.shadow_overlay&.x,
      renderable.shadow_overlay&.y
    )
  end

  def draw_text(renderable)
    text = find_or_create_text(renderable)

    if renderable.destroyed?
      Platform.remove_text(text)
    else
      Platform.set_text_attributes(
        text,
        renderable.text,
        renderable.font_size,
        renderable.font_color,
        renderable.position.x,
        renderable.position.y
      )
    end
  end

  def pool
    @pool ||= {}
  end

  def texture_pool
    @texture_pool ||= {}
  end

  def text_pool
    @texture_pool ||= {}
  end

  def find_or_create_sprite(renderable)
    pool[renderable.id] = (
      pool[renderable.id] || Platform.create_sprite(find_or_create_texture(renderable.sprite_name), renderable.renderable_anchor_point, renderable.z_position)
    )
  end

  def find_or_create_texture(texture_name)
    texture_pool[texture_name] = (
      texture_pool[texture_name] || Platform.create_texture(texture_name)
    )
  end

  def find_or_create_text(renderable)
    text_pool[renderable.id] = (
      text_pool[renderable.id] || Platform.create_text(renderable.font_name, renderable.renderable_anchor_point)
    )
  end

  def camera_game_object
    root.camera
  rescue
    puts "Error: The root game object must have a camera"
    eval(DEBUGGER)
    # exit 1
  end
end
