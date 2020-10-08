class PlatformShape
  def initialize(renderable)
    @renderable = renderable
  end

  def x
    @renderable.position.x
  end

  def y
    @renderable.position.y
  end

  def z
    @renderable.z_position
  end

  def width
    @renderable.size.width
  end

  def height
    @renderable.size.height
  end

  def color
    @renderable.color
  end

  def color_blend_factor
    @renderable.color_blend_factor
  end

  def visible
    @renderable.visible
  end
end
