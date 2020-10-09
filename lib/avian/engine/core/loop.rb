# The game loop.
#
class Loop
  # - parameter root: GameObject::Root instance.
  #
  def initialize(root)
    @root = root
    @renderer = Renderer.new(root)
    @frame_count = 0
    @time_count = 0
  end

  # - parameter current_time: current time in milliseconds.
  #
  def perform_update(current_time)
    # Profiler.shared_instance.end_of("OUTSIDE OF LOOP")

    # Profiler.shared_instance.flush
    # Profiler.shared_instance.start_of("ALL_LOGIC")
    last_time = @last_time || current_time
    milliseconds_delta = current_time - last_time

    # If the game logic is completed in less than 16ms, it's running faster than
    # 60fps. In that case we can just make this thread wait to save on
    # processing.
    if milliseconds_delta < 8
      sleep_time = 8 - milliseconds_delta
      Platform.delay(sleep_time * 0.001)
      milliseconds_delta += sleep_time
    end

    seconds_delta = milliseconds_delta * 0.001
    @last_time = current_time

    Time.delta = seconds_delta
    @time_count = @time_count + seconds_delta
    if @time_count >= 1
      # TODO: enable by app config
      # puts "#{@frame_count} FPS"
      @time_count = 0
      @frame_count = 0
    else
      @frame_count = @frame_count + 1
    end
    # Profiler.shared_instance.start_of("internal input update")
    Input.shared_instance.update
    # Profiler.shared_instance.end_of("internal input update")
    # Profiler.shared_instance.start_of("perform_update")
    @root.perform_update
    # Profiler.shared_instance.end_of("perform_update")

    # Profiler.shared_instance.start_of("draw_frame")
    @renderer.draw_frame
    # Profiler.shared_instance.end_of("draw_frame")

    # Profiler.shared_instance.end_of("ALL_LOGIC")

    # Profiler.shared_instance.start_of("OUTSIDE OF LOOP")
  end
end
