module Math
  module Direction
    HALF_OF_PI = Math::PI / 2
    LEFT = Math::PI
    UP = HALF_OF_PI
    RIGHT = 0
    DOWN = -HALF_OF_PI


    # Works out the radian difference between 2 positional positions.
    #
    # For example:
    #   Given the origin is at (0, 0)
    #   And the comparison is at (2, 3)
    #   Then it returns the radian equivalent of 56.3° (0.982793723247329)
    #
    # - parameter origin: Object that responds to x and y
    # - parameter comparison: Object that responds to x and y
    #
    def positional_difference(origin, comparison)
      relative_x = comparison.x - origin.x
      relative_y = comparison.y - origin.y

      # Note: for some reason `Math.atan2` takes Y first, and then X. 🤷‍♀️
      Math.atan2(relative_y, relative_x)
    end
    module_function :positional_difference

    # Returns how much one positional object should rotate to face another.
    #
    # For example:
    #   Given the origin is facing upwards
    #   And origin is at (0, 0)
    #   And comparison is directly to the right (3, 0)
    #   Then it returns the radian equivalent of 90° (1.5708)
    #
    # - parameter origin: Object that responds to x, y, current_rotation
    # - parameter comparison: Object that responds to x, y
    #
    def rotation_difference(origin, comparison)
      difference = - (positional_difference(origin, comparison) - origin.current_rotation)

      raise "needs more thought" if difference > Math::PI * 2
      raise "needs more thought" if difference < -Math::PI * 2

      if difference > Math::PI # e.g. 4.71238898038469
        difference = -Math::PI + -Math::PI + difference
      elsif difference < -Math::PI # e.g. -4.71238898038469
        difference = Math::PI + Math::PI + difference
      end

      difference
    end
    module_function :rotation_difference

    # Returns the direction multiplier.
    #
    # I.e. left is negative, right is positive, no rotation is zero.
    #
    # - parameter origin: Object that responds to x, y, current_rotation
    # - parameter comparison: Object that responds to x, y
    #
    def direction_to_rotate_multiplier(origin, comparison)
      difference = rotation_difference(origin, comparison)
      return 0 if difference == 0
      difference < 0 ? -1 : 1
    end
    module_function :direction_to_rotate_multiplier
  end
end
