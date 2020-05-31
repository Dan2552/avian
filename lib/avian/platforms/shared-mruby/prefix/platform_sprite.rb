class PlatformSprite
  def initialize(texture, anchor_point)
    @texture = texture
    @anchor_point = anchor_point
    @visible = true
    @color_blend_factor = 0
  end

  attr_accessor :anchor_point
  attr_accessor :texture
  attr_accessor :x
  attr_accessor :y
  attr_accessor :z
  attr_accessor :angle
  attr_accessor :center_x
  attr_accessor :center_y
  attr_accessor :x_scale
  attr_accessor :y_scale
  attr_accessor :visible
  attr_accessor :color
  attr_accessor :color_blend_factor
end
