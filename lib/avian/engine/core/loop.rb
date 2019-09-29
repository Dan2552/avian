# The game loop.
#
class Loop
  # - parameter root: GameObject::Root instance.
  #
  def initialize(root)
    @root = root
  end

  # - parameter current_time: current time in milliseconds.
  #
  def perform_update(current_time)
    RenderList.shared_instance.clear!
    # Profiler.shared_instance.flush
    last_time = @last_time || current_time
    milliseconds_delta = current_time - last_time

    # If the game logic is completed in less than 16ms, it's running faster than
    # 60fps. In that case we can just make this thread wait to save on
    # processing.
    if milliseconds_delta < 16
      sleep_time = 16 - milliseconds_delta
      sleep(sleep_time * 0.001)
      milliseconds_delta += sleep_time
    end

    seconds_delta = milliseconds_delta * 0.001
    @last_time = current_time

    Time.delta = seconds_delta
    Input.shared_instance.update
    root.perform_update
    renderer.draw_frame
  end

  private

  attr_reader :root

  def renderer
    @renderer ||= Renderer.new(root)
  end
end
