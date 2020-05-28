puts "THIS IS RUBY"
class ExitError < StandardError; end
class PlatformRenderStore
  def sprites
    @sprites ||= []
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

  bridge.draw_image(
    sprite.texture,
    sprite.x.to_i,
    Platform.camera.height - sprite.y.to_i,
    sprite.z.to_i,
    sprite.angle.to_f,
    sprite.center_x.to_i,
    sprite.center_y.to_i,
    sprite.x_scale.to_f,
    sprite.y_scale.to_f,
    Platform.camera.x.to_i,
    -Platform.camera.y.to_i,
    Platform.camera.x_scale.to_f,
    Platform.camera.y_scale.to_f
  )
end

def handle_inputs(state, id, x, y)
  return if state == :empty
  # puts "#{state} #{id} : #{x},#{y}"

  puts "ruby: #{Platform.screen_size.width}x#{Platform.screen_size.height}"
  # x = x - Platform.screen_size.width * 0.5
  # y = y - Platform.screen_size.height * 0.5

  y = Platform.screen_size.height - y

  x = x * 0.5
  y = y * 0.5

  case state
  when :touch_down
    Input.shared_instance.touch_did_begin(id, Vector[x, y])
  when :touch_up
    Input.shared_instance.touch_did_end(id, Vector[x, y])
  when :touch_move
    puts "#{state} #{id} : #{x},#{y}"
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
  puts "primary_scene: #{primary_scene}"
  scenario = primary_scene.new
  game_loop ||= Loop.new(scenario.root)

  loop do
    # call to C to update inputs - i.e. calls SDL_PollEvent
    loop do
      more, state, id, x, y = bridge.update_inputs
      handle_inputs(state, id, x, y)
      break unless more == 1
    end

    # run the game loop
    game_loop.perform_update(Time.now.to_f * 1000)

    # render
    bridge.clear_screen

    render_store.sprites
      .sort_by(&:z)
      .each { |sprite| draw(bridge, sprite) }

    bridge.render
  end
end

begin
  run
rescue ExitError
  # Do nothing
rescue Exception => e
  puts "========="
  puts e.inspect
  e.backtrace.each do |line|
    puts line unless line.end_with?(":in method_missing")
  end
  puts "========="
end
