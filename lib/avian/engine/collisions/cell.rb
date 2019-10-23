module Collisions
  # A single cell from a CollisionGrid.
  #
  class Cell
    # The co-ordinates the cell originates in the CollisionGrid.
    #
    attr_reader :row, :col

    def initialize(row, col)
      @row = row
      @col = col
    end

    def <<(game_object)
      elements[game_object.id] = game_object
    end

    def delete(game_object)
      elements.delete(game_object.id)
    end

    def each(*args, &blk)
      elements.values.each(*args, &blk)
    end

    def include?(game_object)
      elements[game_object.id].present?
    end

    private

    def elements
      @elements ||= {}
    end
  end
end
