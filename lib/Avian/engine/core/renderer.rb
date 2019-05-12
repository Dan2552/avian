# Responsible for rendering the game graph's objects on screen.
#
class Renderer
  # parameter root: The root GameObject instance.
  #
  def initialize(root)
    @root = root
  end

  # Draws a frame on the screen. The Loop should call this once per frame after
  # running through the logic.
  #
  def draw_frame
    Platform.set_sprite_position(camera_node, camera_game_object.position, nil)
    Platform.set_scale(camera_node, camera_game_object.scale)
    traverse
  end

  private

  attr_reader :root

  def traverse
    RenderList.shared_instance.each do |game_object|
      draw(game_object)
    end
  end

  def draw(renderable)
    sprite_node = find_or_create_sprite(renderable)

    if renderable.destroyed?
      Platform.remove_sprite(sprite_node)
    else
      Platform.set_sprite_texture(sprite_node, find_or_create_texture(renderable.sprite_name))
      Platform.set_sprite_position(sprite_node, renderable.renderable_position, renderable.renderable_z_position)
      Platform.set_sprite_rotation(sprite_node, renderable.rotation)
      Platform.set_sprite_flipped(sprite_node, renderable.flipped_vertically, renderable.flipped_horizontally)
    end
  end

  def pool
    @pool ||= {}
  end

  def texture_pool
    @texture_pool ||= {}
  end

  def find_or_create_sprite(renderable)
    pool[renderable.id] = (
      pool[renderable.id] || Platform.create_sprite(find_or_create_texture(renderable.sprite_name), renderable.renderable_anchor_point)
    )
  end

  def find_or_create_texture(texture_name)
    texture_pool[texture_name] = (
      texture_pool[texture_name] || Platform.create_texture(texture_name)
    )
  end

  def camera_node
    @camera_node ||= Platform.camera
  end

  def camera_game_object
    root.camera
  rescue
    puts "Error: The root game object must have a camera"
    exit 1
  end
end
