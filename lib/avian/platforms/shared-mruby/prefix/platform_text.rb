class PlatformText
  def initialize(font_name, anchor_point)
    @font_name = font_name
    @anchor_point = anchor_point
  end

  attr_reader :font_name
  attr_reader :anchor_point
  attr_accessor :text
  attr_accessor :font_size
  attr_accessor :font_color
  attr_accessor :x
  attr_accessor :y
  attr_accessor :alignment
end
