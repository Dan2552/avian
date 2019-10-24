module Collisions
  class IncrementalMovement < Behavior
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
      @original_position = @game_object.position

      @remaining_x = vector.x
      @remaining_y = vector.y

      step_increment
    end

    private

    def step_increment
      current_increment = :x

      while @remaining_x > 0 || @remaining_y > 0
        if current_increment == :x
          move_by_x if @remaining_x > 0
          current_increment = :y
        elsif current_increment == :y
          move_by_y if @remaining_y > 0
          current_increment = :x
        end
      end
    end

    def move_by_x
      puts "about to move by x ----- remaining: #{@remaining_x} -------"

      this_increment = [@increment, @remaining_x].min
      new_x = @game_object.position.x + this_increment

      previous_position = @game_object.position
      @game_object.position = Vector[new_x, @game_object.position.y]

      if @collision_check.call != true # there is a collision
        @game_object.position = previous_position
        @remaining_x = 0
      end

      @remaining_x = @remaining_x - this_increment
    end

    def move_by_y
      puts "about to move by y ----- remaining: #{@remaining_y} -------"

      this_increment = [@increment, @remaining_y].min
      new_y = @game_object.position.y + this_increment

      previous_position = @game_object.position
      @game_object.position = Vector[@game_object.position.x, this_increment]

      if @collision_check.call != true # there is a collision
        @game_object.position = previous_position
        @remaining_y = 0
      end

      @remaining_y = @remaining_y - this_increment
    end
  end
end
