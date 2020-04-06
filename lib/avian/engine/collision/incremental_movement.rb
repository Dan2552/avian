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
  class IncrementalMovement < Behavior
    # - parameter game_object: GameObject instance.
    #
    # - parameter increment: The number to move in each iteration.
    #
    def initialize(game_object, increment)
      if game_object.size.zero?
        raise "A game object that has no size cannot be added to IncrementalMovement"
      end

      @game_object = game_object
      @increment = increment.abs
      @decimal_places = increment.to_s.split(".").last.length
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
    # Note: when using `move`, the game object's position will be set to the
    # same precision as the increment. E.g. if the player's resulting
    # `position.x` would be `0.31`, and the increment was set as `0.1`, the
    # value would be set as `0.3`.
    #
    def move(vector, &collision_check)
      @vector = vector
      @collision_check = collision_check

      @remaining_x = vector.x.abs
      @remaining_y = vector.y.abs

      @x_operator = :+ if vector.x > 0
      @x_operator = :- if vector.x < 0

      @y_operator = :+ if vector.y > 0
      @y_operator = :- if vector.y < 0

      step_increment
    end

    private

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
        new_x = @game_object.position.x + this_increment
      elsif @x_operator == :-
        new_x = @game_object.position.x - this_increment
      end

      # puts "moving by #{this_increment}"

      previous_position = @game_object.position
      @game_object.position = Vector[
        new_x.round(@decimal_places),
        @game_object.position.y
      ]

      @remaining_x = (@remaining_x - this_increment).round(@decimal_places).abs

      if @collision_check.call != true # there is a collision
        @game_object.position = previous_position
        @remaining_x = 0
      end
    end

    def move_by_y
      @y_times ||= 0
      @y_times += 1
      # puts "#{@y_times} about to move by y ----- remaining: #{@remaining_y} -------"

      this_increment = [@increment, @remaining_y.abs].min

      if @y_operator == :+
        # puts "adding"
        new_y = @game_object.position.y + this_increment
      elsif @y_operator == :-
        # puts "subtracting"
        new_y = @game_object.position.y - this_increment
      end

      # puts "moving by #{this_increment}"

      previous_position = @game_object.position
      @game_object.position = Vector[
        @game_object.position.x,
        new_y.round(@decimal_places)
      ]

      # puts "new position: #{@game_object.position}"

      @remaining_y = (@remaining_y - this_increment).round(@decimal_places).abs

      if @collision_check.call != true # there is a collision
        # puts "there's a collision"
        @game_object.position = previous_position
        @remaining_y = 0
      end
    end
  end
end
