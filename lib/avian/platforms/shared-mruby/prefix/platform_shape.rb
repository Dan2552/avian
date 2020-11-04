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
    @renderable.z_position.value
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

  def anchor_point
    @renderable.renderable_anchor_point
  end

  def x_scale
    @renderable.x_scale
  end

  def y_scale
    @renderable.y_scale
  end

  def opacity
    @renderable.opacity
  end
end
