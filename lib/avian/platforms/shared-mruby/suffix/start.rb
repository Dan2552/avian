puts "THIS IS RUBY"

class PlatformRenderStore
  def sprites
    @sprites ||= []
  end
end

def draw(bridge, sprite)
  # TODO: camera
  # TODO: if the object isn't in the camera's view, don't draw it

  puts "(ruby) draw (#{sprite.x.class},#{sprite.y.class})"

  bridge.draw_image(
    sprite.texture,
    sprite.x,
    sprite.y
    # sprite.z,
    # sprite.angle,
    # sprite.center_x,
    # sprite.center_y,
    # sprite.scale_x,
    # sprite.scale_y
  )
end

def run
  bridge = Avian::CBridge.new
  render_store = Platform.render_store = PlatformRenderStore.new

  bridge.provision_sdl

  config = Avian::Application.main.config
  primary_scene = config.primary_scene
  puts "primary_scene: #{primary_scene}"
  scenario = primary_scene.new
  game_loop ||= Loop.new(scenario.root)

  loop do
    # call to C to update inputs - i.e. calls SDL_PollEvent
    bridge.update_inputs

    # run the game loop
    game_loop.perform_update(Time.now.to_f * 1000)

    # call to C to clear screen
    bridge.clear_screen
    # bridge.draw_test_rect
    render_store.sprites.each { |sprite| draw(bridge, sprite) }
    # run the game renderer
    # TODO
  end
end

begin
  run
rescue Exception => e
  puts "========="
  puts e.inspect
  e.backtrace.each do |line|
    puts line unless line.end_with?(":in method_missing")
  end
  puts "========="
end