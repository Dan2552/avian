class ExitError < StandardError; end


class PlatformInput
  def initialize
    @x = 1
  end

  attr_reader :x
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

  platform_input = PlatformInput.new

  bridge.provision_sdl

  config = Avian::Application.main.config
  primary_scene = config.primary_scene
  scenario = primary_scene.new
  game_loop = Loop.new(scenario.root)


  loop do
    # call to C to update inputs - i.e. calls SDL_PollEvent
    loop do
      more, state, id, x, y = bridge.update_inputs
      handle_inputs(state, id, x, y)
      break unless more == 1
    end

    game_loop.perform_update(Time.now.to_f * 1000)
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
