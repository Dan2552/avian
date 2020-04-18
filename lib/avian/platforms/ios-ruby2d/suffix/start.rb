puts "loading start"
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

  # Triangle.new(
  #   x1: 320, y1:  50,
  #   x2: 540, y2: 430,
  #   x3: 100, y3: 430,
  #   color: ['red', 'green', 'blue']
  # )

  show

rescue Exception => e
  puts "========="
  puts e.inspect
  e.backtrace.each do |line|
    # file, line_no, rest = line.split(":", 3)
    puts line unless line.end_with?(":in method_missing")
    # puts "  " + [file, (line_no.to_i + 12).to_s, rest].join(":")
  end
  puts "========="
  # lines no sometimes seem to be off ~14 lines?
end
