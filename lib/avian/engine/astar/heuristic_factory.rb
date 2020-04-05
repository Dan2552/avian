module AStar
  # A heuristic is a lambda that takes two arguments (Vertex, Vertex) and returns
  # a Double
  #
  # this factory contains lambdas used to calculate heuristic.
  #
  class HeuristicFactory
    # Returns a function used to calculate heuristic between two
    # nodes for a 2D grid.
    #
    # Assumption is that `x` and `y` are set with the position
    # of the vertex within the 2D grid.
    #
    # (compatible when using `GraphFactory#two_dimensional_graph`)
    #
    def two_dimensional_manhatten_heuristic
      -> (lhs, rhs) do
        lhs_x = lhs.x
        lhs_y = lhs.y
        rhs_x = rhs.x
        rhs_y = rhs.y

        x = [lhs_x, rhs_x].max - [lhs_x, rhs_x].min
        y = [lhs_y, rhs_y].max - [lhs_y, rhs_y].min

        (x + y).abs.to_f
      end
    end

    # TODO:
    # http://theory.stanford.edu/~amitp/GameProgramming/MapRepresentations.html
    # A piece of information A* needs is travel times between the points. That will be manhattan distance or diagonal grid distance if your units move on a grid, or straight line distance if they can move directly between the navigation points.
    # http://theory.stanford.edu/~amitp/GameProgramming/Heuristics.html#euclidean-distance
  end
end
