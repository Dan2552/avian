begin
  config = Avian::Application.main.config
  primary_scene = config.primary_scene
  puts "primary_scene: #{primary_scene}"
  scenario = primary_scene.new
  game_loop ||= Loop.new(scenario.root)

  update do
    current_time = Time.now.to_f
    @loop.perform_update(current_time * 1000)
  end

  show
rescue Exception => e
  puts e.inspect
  puts e.backtrace
  # TODO: lines always seem to be off 14 lines?
  raise e
end
