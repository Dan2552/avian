module GameObject
  # Can be set on a `GameObject#shadow_overlay`.
  #
  class BasicShadow
    # - parameter options:
    #   - :image, defaults to "shadow"
    #   - :x
    #   - :y
    #
    def initialize(options = {})
      @image = options[:image] || "shadow"
      @x = options[:x]
      @y = options[:y]
    end

    # The x co-ordinate from _which part of the shadow image_ should be used
    #
    # Note: the width used will be the same width as the object you're applying
    # the shadow to.
    #
    attr_accessor :x

    # The y co-ordinate from _which part of the shadow image_ should be used
    #
    # Note: the height used will be the same height as the object you're
    # applying the shadow to.
    #
    attr_accessor :y

    # The image used to create the shadow effect.
    #
    attr_reader :image
  end
end
