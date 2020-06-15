class PlatformText
  def initialize(font_name)
    @font_name = font_name
  end

  attr_reader :font_name
  attr_accessor :text
  attr_accessor :font_size
  attr_accessor :font_color
  attr_accessor :x
  attr_accessor :y
  attr_accessor :alignment
end
