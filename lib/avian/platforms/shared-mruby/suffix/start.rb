class ExitError < StandardError; end

class PlatformInput
  def initialize
    @x = 1
  end

  attr_reader :x
end

INPUT_QUIT = -1
INPUT_EMPTY = 0
INPUT_TOUCH_UP = 1
INPUT_TOUCH_DOWN = 2
INPUT_TOUCH_MOVE = 3
INPUT_KEY_DOWN = 4
INPUT_KEY_UP = 5

INPUT_RETURN_TYPE_QUIT = -1
INPUT_RETURN_TYPE_TOUCH = 0
INPUT_RETURN_TYPE_KEY = 1

class Main
  # Returns true if SDL hasn't got another event already lined up (as in, we
  # already processed all in the queue).
  #
  def handle_input(input)
    case input[0]
    when INPUT_RETURN_TYPE_QUIT
      raise ExitError
    when INPUT_RETURN_TYPE_TOUCH
      _, more, state, id, x, y = input
      handle_touch_inputs(state, id, x, y)
    when INPUT_RETURN_TYPE_KEY
      puts "GOT A KEYPRESS"
      _, more, state, key, repeat = input
      handle_keypress_input(state, key.chr, repeat)
    end
  end

  def handle_touch_inputs(state, id, x, y)
    y = Platform.screen_size.height - y

    case state
    when INPUT_TOUCH_DOWN
      Input.shared_instance.touch_did_begin(id, Vector[x, y])
    when INPUT_TOUCH_UP
      Input.shared_instance.touch_did_end(id, Vector[x, y])
    when INPUT_TOUCH_MOVE
      Input.shared_instance.touch_did_move(id, Vector[x, y])
    when :quit
      raise ExitError
    end
  end

  def handle_keypress_input(state, key, repeat)
    case state
    when :key_up
      Input.shared_instance.key_did_end(key)
    when :key_down
      if repeat == 1
        Input.shared_instance.key_did_repeat(key)
      else
        Input.shared_instance.key_did_begin(key)
      end
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
        input = bridge.update_inputs
        break unless input
        break unless handle_input(input)
      end

      game_loop.perform_update(Time.now.to_f * 1000)
    end
  end
end

begin
  module Kernel
    def self.started
    end
  end
  Main.new.run
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
