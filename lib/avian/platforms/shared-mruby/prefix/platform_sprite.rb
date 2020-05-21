class PlatformSprite
  def initialize(texture, anchor_point)
    @texture = texture
    @anchor_point = anchor_point
  end

  attr_reader :texture
  attr_accessor :x
  attr_accessor :y
  attr_accessor :z
  attr_accessor :angle
  attr_accessor :center_x
  attr_accessor :center_y
  attr_accessor :scale_x
  attr_accessor :scale_y
end
