class PlatformCamera
  def initialize(width, height)
    @width = width
    @height = height
  end

  attr_accessor :x
  attr_accessor :y
  attr_accessor :width
  attr_accessor :height
  attr_accessor :x_scale
  attr_accessor :y_scale
end
