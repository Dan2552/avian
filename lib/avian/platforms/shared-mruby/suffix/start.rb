puts "THIS IS RUBY"

class PlatformRenderStore
  def sprites
    @sprites ||= []
  end
end

def draw(bridge, sprite)
  # TODO: if the object isn't in the camera's view, don't draw it

  return unless sprite.visible

  bridge.draw_image(
    sprite.texture,
    sprite.x.to_i,
    sprite.y.to_i,
    sprite.z.to_i,
    sprite.angle.to_f,
    sprite.center_x.to_i,
    sprite.center_y.to_i,
    sprite.x_scale.to_f,
    sprite.y_scale.to_f,
    Platform.camera.x.to_i,
    Platform.camera.y.to_i,
    Platform.camera.x_scale.to_f,
    Platform.camera.y_scale.to_f
  )
end

def run
  bridge = Avian::CBridge.new

  render_store = Platform.render_store = PlatformRenderStore.new
  Platform.camera = PlatformCamera.new(
    bridge.get_screen_width,
    bridge.get_screen_height
  )

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
    bridge.render
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
