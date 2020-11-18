class PlatformSprite
  def initialize(renderable, z)
    @renderable = renderable
    @z = z

    raise "z required" if z.nil?
  end

  attr_reader :z

  attr_accessor :texture
  attr_accessor :shadow_texture

  def reset!
    return if renderable.static_renderable

    @anchor_point = nil
    @x = nil
    @y = nil
    @x_scale = nil
    @y_scale = nil
    @visible = nil
    @color = nil
    @color_blend_factor = nil
    @shadow_x = nil
    @shadow_y = nil
  end

  def anchor_point
    @anchor_point ||= renderable.renderable_anchor_point
  end

  def x
    @x ||= renderable.position.x
  end

  def y
    @y ||= renderable.position.y
  end

  def x_scale
    @x_scale ||= renderable.x_scale
  end

  def y_scale
    @y_scale ||= renderable.y_scale
  end

  def visible
    @visible ||= renderable.visible
  end

  def color
    @color ||= renderable.color
  end

  def color_blend_factor
    @color_blend_factor ||= renderable.color_blend_factor
  end

  def shadow_x
    @shadow_x ||= renderable.shadow_overlay&.x
  end

  def shadow_y
    @shadow_y ||= renderable.shadow_overlay&.y
  end

  private

  attr_reader :renderable
end
