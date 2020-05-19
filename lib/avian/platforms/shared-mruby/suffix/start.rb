puts "THIS IS RUBY"

def run
  bridge = Avian::CBridge.new

  bridge.provision_sdl

  config = Avian::Application.main.config
  primary_scene = config.primary_scene
  puts "primary_scene: #{primary_scene}"
  scenario = primary_scene.new
  game_loop ||= Loop.new(scenario.root)

  bridge.create_texture("hello rstringpointer")

  # loop do
  #   # call to C to update inputs - i.e. calls SDL_PollEvent
  #   bridge.update_inputs

  #   # run the game loop
  #   game_loop.perform_update(Time.now.to_f * 1000)

  #   # call to C to clear screen
  #   bridge.clear_screen
  #   bridge.draw_test_rect
  #   # run the game renderer


  #   # TODO
  # end
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
