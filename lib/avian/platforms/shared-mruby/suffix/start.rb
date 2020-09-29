class ExitError < StandardError; end
class PlatformRenderStore
  def sprites
    @sprites ||= []
  end

  def texts
    @texts ||= []
  end
end

class PlatformInput
  def initialize
    @x = 1
  end

  attr_reader :x
end

def draw(bridge, sprite)
  # TODO: if the object isn't in the camera's view, don't draw it

  return unless sprite.visible

  red = 0
  green = 0
  blue = 0

  if sprite.color_blend_factor > 0
    red = (sprite.color >> 16) & 255
    green = (sprite.color >> 8) & 255
    blue = sprite.color & 255
  end

  bridge.draw_image(
    sprite.texture,
    sprite.x.to_i,
    Platform.camera.height - sprite.y.to_i,
    sprite.z.to_i,
    sprite.angle.to_f,
    sprite.anchor_point.x,
    sprite.anchor_point.y,
    sprite.x_scale.to_f,
    sprite.y_scale.to_f,
    Platform.camera.x.to_i,
    -Platform.camera.y.to_i,
    Platform.camera.x_scale.to_f,
    Platform.camera.y_scale.to_f,
    red,
    green,
    blue,
    sprite.color_blend_factor,
    sprite.shadow_texture || -1,
    sprite.shadow_x.to_i,
    sprite.shadow_y.to_i
  )
end

def draw_text(bridge, text)
  return unless text.text.length > 0

  texture = bridge.create_texture_for_text(
    text.text,
    text.font_size
  )

  sprite = PlatformSprite.new(texture, text.anchor_point)
  sprite.x = text.x
  sprite.y = text.y
  sprite.color = text.font_color
  sprite.color_blend_factor = 1.0

  draw(bridge, sprite)

  bridge.pop_texture
end

def handle_inputs(state, id, x, y)
  return if state == :empty

  y = Platform.screen_size.height - y

  case state
  when :touch_down
    Input.shared_instance.touch_did_begin(id, Vector[x, y])
  when :touch_up
    Input.shared_instance.touch_did_end(id, Vector[x, y])
  when :touch_move
    Input.shared_instance.touch_did_move(id, Vector[x, y])
  when :quit
    raise ExitError
  end
end

def run
  bridge = Avian::CBridge.new

  render_store = Platform.render_store = PlatformRenderStore.new
  Platform.camera = PlatformCamera.new(
    bridge.get_screen_width,
    bridge.get_screen_height
  )

  platform_input = PlatformInput.new

  bridge.provision_sdl

  config = Avian::Application.main.config
  primary_scene = config.primary_scene
  scenario = primary_scene.new
  game_loop ||= Loop.new(scenario.root)

  loop do
    # Profiler.shared_instance.start_of("C-inputs")
    # call to C to update inputs - i.e. calls SDL_PollEvent
    loop do
      more, state, id, x, y = bridge.update_inputs
      handle_inputs(state, id, x, y)
      break unless more == 1
    end
    # Profiler.shared_instance.end_of("C-inputs")
    # run the game loop
    game_loop.perform_update(Time.now.to_f * 1000)

    # Profiler.shared_instance.start_of("C-render-clear")
    # render
    bridge.clear_screen
    # Profiler.shared_instance.end_of("C-render-clear")

    # Profiler.shared_instance.start_of("C-render-draw")
    render_store.sprites
      .each { |sprite| draw(bridge, sprite) }
    # Profiler.shared_instance.end_of("C-render-draw")

    render_store.texts
      .each { |text| draw_text(bridge, text) }

    # Profiler.shared_instance.end_of("C-render-render")
    bridge.render
    # Profiler.shared_instance.end_of("C-render-render")
  end
end

begin
  run
rescue ExitError
  # Do nothing
rescue Exception => e
  puts ""
  puts "\e[31m#{e.inspect}\e[0m"
  e.backtrace.each do |line|
    next if line.include?("avian/platforms/shared-mruby/prefix/debugging.rb")
    puts "\e[36m#{line}\e[0m"
  end
end
