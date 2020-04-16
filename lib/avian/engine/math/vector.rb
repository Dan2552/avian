module Math
  module Vector
    # - parameter current_position: The originating position Vector.
    # - parameter target_position: The destination postiion Vector.
    # - parameter maximum_step: If you were to call this method once per frame,
    #   this would be the maximum amount you'd want the movement to be in that
    #   single frame. E.g. could be the speed. Consider `speed * Time.delta`.
    #
    def self.move_towards(current_position, target_position, maximum_step)
      vector = target_position - current_position

      if vector.magnitude > maximum_step
        vector = vector.normalize * maximum_step
      end

      vector
    end
  end
end
