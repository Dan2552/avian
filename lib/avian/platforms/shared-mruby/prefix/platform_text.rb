class PlatformText
  def initialize(renderable)
    @renderable = renderable
  end

  attr_reader :renderable

  def font_name
    renderable.font_name
  end

  def anchor_point
    renderable.renderable_anchor_point
  end

  def text
    renderable.text
  end

  def font_size
    renderable.font_size
  end

  def color
    0xff_000000 + renderable.color
  end

  def color_blend_factor
    renderable.color_blend_factor
  end

  def position
    renderable.position
  end

  def x
    renderable.position.x
  end

  def y
    renderable.position.y
  end

  def z
    renderable.z_position.value
  end

  def visible
    renderable.visible
  end

  private

  attr_reader :renderable
end
