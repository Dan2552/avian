module Collision
  # IncrementalMovement can be used to move an object incrementally whilst
  # checking agaisn't collisions.
  #
  # This is best explained by example. Say there is a player object, and a
  # barrier:
  #
  # - The barrier's width is `6`
  # - The player's velocity is `Vector[0, 10]`
  #
  # In this case, if the player were moved by the velocity directly in a single
  # frame, the player's frame could never actually intersect with the barrier's.
  # Instead with IncrementalMovement, if the increment value were set to `1`
  # the player would move at a rate of `Vector[0, 1]` between collision checks.
  #
  # IncrementalMovement runs a loop, so in the given example, the player would
  # still move at a rate of `Vector[0, 10]` in a single frame.
  #
  class IncrementalMovement
    # - parameter game_object: GameObject instance.
    #
    # - parameter increment: The number to move in each iteration.
    #
    def initialize(current_position, increment)
      @original_position = current_position
      @current_position = current_position
      @increment = increment.abs.to_f
      @decimal_places = increment.to_s.split(".").last.length
    end

    # Reduce the given vector if the vector would result in collisions.
    #
    # This can be used for moving game objects towards a direction but preventing
    # them collide with other objects.
    #
    # E.g. if the vector were [2, 1], but there's a wall above, and therefore
    # there should be no upwards movement, the returned value would be [2, 0].
    #
    # Incrementally move by the given vector at the increment rate.
    #
    # - parameter vector: How much to move by. E.g. Vector[1, 1] would move up
    #   and right by 1.
    #
    # - parameter collision_check: This block will be queried at each increment,
    #   to ensure the object isn't colliding with something. If the block yields
    #   a `false`, the current increment will be cancelled.
    #
    # Note: when using `move`, the game object's position will be set to the
    # same precision as the increment. E.g. if the player's resulting
    # `position.x` would be `0.31`, and the increment was set as `0.1`, the
    # value would be set as `0.3`.
    #
    def reduce_vector(vector, &collision_check)
      @vector = vector
      @collision_check = collision_check

      @remaining_x = vector.x.abs.to_f
      @remaining_y = vector.y.abs.to_f

      @x_operator = :+ if vector.x > 0
      @x_operator = :- if vector.x < 0

      @y_operator = :+ if vector.y > 0
      @y_operator = :- if vector.y < 0

      step_increment

      current_position - original_position
    end

    private

    attr_reader :original_position
    attr_reader :current_position

    def step_increment
      current_increment = :x

      while @remaining_x > 0 || @remaining_y > 0 || @remaining_x < 0 || @remaining_y < 0
        if current_increment == :x
          move_by_x if @remaining_x > 0 || @remaining_x < 0
          current_increment = :y
        elsif current_increment == :y
          move_by_y if @remaining_y > 0 || @remaining_y < 0
          current_increment = :x
        end
      end
    end

    def move_by_x
      @x_times ||= 0
      @x_times += 1
      # puts "#{@x_times} about to move by x ----- remaining: #{@remaining_x} -------"

      this_increment = [@increment, @remaining_x.abs].min

      if @x_operator == :+
        new_x = current_position.x + this_increment
      elsif @x_operator == :-
        new_x = current_position.x - this_increment
      end

      # puts "moving by #{this_increment}"

      previous_position = current_position
      @current_position = Vector[
        new_x.round(@decimal_places),
        current_position.y
      ]

      @remaining_x = (@remaining_x - this_increment).round(@decimal_places).abs

      if @collision_check.call(current_position) != true # there is a collision
        @current_position = previous_position
        @remaining_x = 0.0
      end
    end

    def move_by_y
      @y_times ||= 0
      @y_times += 1
      # puts "#{@y_times} about to move by y ----- remaining: #{@remaining_y} -------"

      this_increment = [@increment, @remaining_y.abs].min

      if @y_operator == :+
        # puts "adding"
        new_y = current_position.y + this_increment
      elsif @y_operator == :-
        # puts "subtracting"
        new_y = current_position.y - this_increment
      end

      # puts "moving by #{this_increment}"

      previous_position = current_position
      @current_position = Vector[
        current_position.x,
        new_y.round(@decimal_places)
      ]

      # puts "new position: #{current_position}"

      @remaining_y = (@remaining_y - this_increment).round(@decimal_places).abs

      if @collision_check.call(current_position) != true # there is a collision
        # puts "there's a collision"
        @current_position = previous_position
        @remaining_y = 0.0
      end
    end
  end
end
