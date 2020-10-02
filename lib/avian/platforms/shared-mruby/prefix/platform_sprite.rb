class PlatformSprite
  def initialize(renderable)
    @renderable = renderable
  end

  attr_accessor :texture
  attr_accessor :shadow_texture

  def anchor_point
    renderable.renderable_anchor_point
  end

  def x
    renderable.position.x
  end

  def y
    renderable.position.y
  end

  def z
    renderable.z_position
  end

  def angle
    0
  end

  def x_scale
    renderable.x_scale
  end

  def y_scale
    renderable.y_scale
  end

  def visible
    renderable.visible
  end

  def color
    renderable.color
  end

  def color_blend_factor
    renderable.color_blend_factor
  end

  def shadow_x
    renderable.shadow_overlay&.x
  end

  def shadow_y
    renderable.shadow_overlay&.y
  end

  private

  attr_reader :renderable
end
