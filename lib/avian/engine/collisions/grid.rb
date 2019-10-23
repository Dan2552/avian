# if(left_tile < 0) left_tile = 0
# if(right_tile > tilemap.width) right_tile = tilemap.width
# if(top_tile < 0) top_tile = 0
# if(bottom_tile > tilemap.height) bottom_tile = tilemap.height

# any_collision = false
# for(i=left_tile; i<=right_tile; i++)
# {
#   for(j=top_tile; j<=bottom_tile; j++)
#   {
#     tile t = tilemap.tile_at(i, j)
#     if(t.is_wall)
#     {
#       any_collision = true
#     }
#   }
# }

# class PlayerFactory
#   def self.build
#     player = Player.new
#     player.incremental_movement =
#       Collisions::IncrementalMovement.new(player, 0.1)
#     player
#   end
# end

# class Player
#   behavior :incremental_movement

#   def update
#     move_in_direction
#   end

#   def move_in_direction
#     movement_vector = Vector[
#       input.vector.x * SPEED.x,
#       input.vector.y * SPEED.y
#     ]

#     nearest_objects = map.collisions.nearest_objects_to(self)

#     move(movement_vector) do
#       nearest_objects.none? { |nearby| nearby.frame.intersects?(frame) }
#     end
#   end
# end

module Collisions
  # A collision grid keeps track of collidable game objects. To determine
  # whether one object is colliding with another, it's much more optimal to only
  # check objects close to the other. This can be achieved by keeping track of
  # objects on a grid.
  #
  class Grid
    # - parameter size: Size instance. The size of the grid. For example, for a
    #   2D tiled map, you would set this to the same size as the map.
    #
    # - parameter cell_size: Size instance. This determines how big a cell
    #   should be. If your map is large and scarce, you may want to increase
    #   this number to use less memory, but if there are a likely to be a lot of
    #   game objects close to each other, it's best to keep this fairly low. For
    #   a 2D tiled map game, you could simply make this the same size as a tile.
    #
    def initialize(size, cell_size)
      @size = size
      @cell_size = cell_size
      @store = []

      x_cell_count = size.width / cell_size.width
      y_cell_count = size.height / cell_size.height

      y_cell_count.times do |row|
        arr_for_row = []
        x_cell_count.times do |col|
          arr_for_row << Collisions::Cell.new(row, col)
        end
        @store << arr_for_row
      end
    end

    # Adds a game object to be tracked in the grid.
    #
    # This should be called when loading the game map, and if any new collidable
    # objects spawn.
    #
    # - parameter game_object: GameObject instance.
    #
    def add!(game_object)
      cells = cells_for(game_object.frame)
      cells.each { |c| c << game_object }
    end

    # Keeps track of a moving game object.
    #
    # This should be called if the object's position has changed. For an object
    # that is constantly moving, this should be called once per frame.
    #
    # - parameter game_object: GameObject instance.
    #
    def move!(game_object)
      old_cells = cells_for(game_object.previous_frame[:frame])
      new_cells = cells_for(game_object.frame)

      return if old_cells == new_cells

      old_cells.each { |c| c.delete(game_object) }
      new_cells.each { |c| c << game_object }
    end

    # Removes tracking of a game object.
    #
    # This should be called if the object is no longer in the map.
    #
    # - parameter game_object: GameObject instance.
    #
    def remove!(game_object)
      old_cells = cells_for(game_object.previous_frame[:frame])
      new_cells = cells_for(game_object.frame)

      old_cells.each { |c| c.delete(game_object) }
      new_cells.each { |c| c.delete(game_object) }
    end

    # Returns an array of objects that are close to the given game object,
    # within the given depth.
    #
    # - parameter game_object: GameObject instance.
    #
    # - parameter depth: Integer value on how many cells beyond the given game
    #   object's cell(s) should be looked into.
    #
    def nearest_objects_to(game_object, depth)
      unless game_objects[game_object]
        raise "The supplied #{game_object.class} has not been added to the grid"
      end
      []
    end

    private

    attr_reader :size,
                :cell_size,
                :store

    def cells_for(frame)
      return [] if frame.nil?

      leftmost = frame.left / cell_size.width
      rightmost = frame.right / cell_size.width
      topmost = frame.top / cell_size.height
      bottommost = frame.bottom / cell_size.height

      cells = []
      (leftmost..rightmost).each do |x|
        (topmost..bottommost).each do |y|
          cells << store[x][y]
        end
      end
      cells
    end
  end
end
