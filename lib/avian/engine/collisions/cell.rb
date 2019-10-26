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

    def all
      elements.values
    end

    def inspect
      "#<Collisions::Cell:#{col}, #{row}>"
    end

    private

    def elements
      @elements ||= {}
    end
  end
end
