module Math
  module Vector
    def self.move_towards(current_position, target_position, maximum_step)
      vector = target_position - current_position

      if vector.magnitude > maximum_step
        vector = vector.normalize * maximum_step
      end

      vector
    end
  end
end
