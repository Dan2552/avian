module Collisions
  class IncrementalMovement
    def initialize(game_object, increment)
      @game_object = game_object
      @increment = increment
    end

    # Incrementally move by the given vector at the increment rate.
    #
    # - parameter vector: How much to move by. E.g. Vector[1, 1] would move up
    #   and right by 1.
    #
    # - parameter collision_check: This block will be queried at each increment,
    #   to ensure the object isn't colliding with something. If the block yields
    #   a `false`, the current increment will be cancelled.
    #
    def move(vector, &collision_check)
      @vector = vector
      @collision_check = collision_check
      @original_position = game_object.position

      step_increment
    end

    private

    attr_reader :game_object,
                :vector

    def step_increment
      # game_object.position +=

      if collision_check.call

      end
    end
  end
end
