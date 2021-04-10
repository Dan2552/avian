module Collision
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

      raise "Incompatible size" unless x_cell_count > 0 && y_cell_count > 0

      y_cell_count.times do |row|
        arr_for_row = []
        x_cell_count.times do |col|
          arr_for_row << Collision::Cell.new(row, col)
        end
        @store << arr_for_row
      end
    end

    # Adds a game object to be tracked in the grid.
    #
    # This should be called when loading the game map, and if any new collidable
    # objects spawn.
    #
    # The object being added must have a size higher than Size[0, 0] to be
    # added.
    #
    # - parameter game_object: GameObject instance.
    #
    def add(game_object)
      if game_object.size.zero?
        raise "A game object that has no size cannot be added to a collision grid"
      end

      cells = cells_for(game_object.frame)
      cells.each { |c| c << game_object }

      # puts "\nadding #{game_object}\n in #{cells}\n\n"
      nil
    end

    # Keeps track of a moving game object.
    #
    # This should be called if the object's position has changed. For an object
    # that is constantly moving, this should be called once per frame.
    #
    # - parameter game_object: GameObject instance.
    #
    def move(game_object)
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
    def remove(game_object)
      cells = cells_for(game_object.frame)

      cells.each { |c| c.delete(game_object) }
    end

    # Returns an array of objects that are close to the given rectangle.
    #
    # - parameter rectangle: Rectangle instance.
    #
    def nearest_objects_to(rectangle)
      x_depth = (rectangle.size.width / cell_size.width)
      y_depth = (rectangle.size.height / cell_size.height)

      x_depth_additions = cell_size.x * x_depth
      y_depth_additions = cell_size.y * y_depth

      frame = Rectangle.new(
        Vector[
          rectangle.left - x_depth_additions,
          rectangle.bottom - y_depth_additions,
        ],
        Size[
          rectangle.size.width + x_depth_additions + x_depth_additions,
          rectangle.size.height + y_depth_additions + y_depth_additions
        ]
      )

      cells_for(frame)
        .map(&:all)
        .flatten
        .uniq
    end

    def inspect
      "#<Collision::Grid>"
    end

    private

    attr_reader :size,
                :cell_size,
                :store

    def cells_for(frame)
      return [] if frame.nil?

      # Here a tiny bit is trimmed off the `right` and `top` values so that if
      # the object is right on the edge of the next tile, it doesn't count as
      # being inside that tile.
      leftmost = (frame.left / cell_size.width).floor
      rightmost = ((frame.right - 0.01) / cell_size.width).floor
      topmost = ((frame.top - 0.01) / cell_size.height).floor
      bottommost = (frame.bottom / cell_size.height).floor

      cells = []

      (leftmost..rightmost).each do |x|
        (bottommost..topmost).each do |y|
          cell = (store[x] || {})[y]
          cells << cell if cell
        end
      end

      cells
    end
  end
end
