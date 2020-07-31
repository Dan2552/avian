class PlatformSprite
  def initialize(texture, anchor_point)
    @texture = texture
    @anchor_point = anchor_point
    @visible = true
    @color_blend_factor = 0

    @z = 0
    @angle = 0
    @x_scale = 1
    @y_scale = 1
    @visible = true
  end

  attr_accessor :anchor_point
  attr_accessor :texture
  attr_accessor :x
  attr_accessor :y
  attr_accessor :z
  attr_accessor :angle
  attr_accessor :x_scale
  attr_accessor :y_scale
  attr_accessor :visible
  attr_accessor :color
  attr_accessor :color_blend_factor
  attr_accessor :shadow_texture
  attr_accessor :shadow_x
  attr_accessor :shadow_y
end
