SCREENSHOT_TYPE = :frames
SCREENSHOT_AFTER = 1
SCREENSHOT_FILEPATH = '/tmp/avian.bmp'

class Screenshotter < GameObject::Base
  def update
    case SCREENSHOT_TYPE
    when :duration
      handle_duration
    when :frames
      handle_frames
    end
  end

  private

  def handle_duration
    every(SCREENSHOT_AFTER.seconds) do
      bridge = Avian::CBridge.new
      bridge.create_screenshot(SCREENSHOT_FILEPATH)
      raise ExitError
    end
  end

  def handle_frames
    @frame_count ||= 0

    if @frame_count >= SCREENSHOT_AFTER
      bridge = Avian::CBridge.new
      bridge.create_screenshot(SCREENSHOT_FILEPATH)
      raise ExitError
    end

    @frame_count = @frame_count + 1
  end
end
