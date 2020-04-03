module AStar
  module GraphFactory
    module_function

    # Creates a graph representing a 2D grid. Sets `info["x"]` and `info["y"]`
    # values as the position for the vertex within the 2D grid.
    #
    # - parameter width: Int
    # - parameter height: Int
    # - returns: Graph
    #
    def two_dimensional_graph(width, height)
      graph = Graph.new
      width.times do |x|
        height.times do |y|
          vertex = Vertex.new("#{x},#{y}", x, y)
          vertex.info["x"] = x
          vertex.info["y"] = y

          graph.add(vertex)

          left = graph.find("#{x - 1},#{y}")
          right = graph.find("#{x + 1},#{y}")
          up = graph.find("#{x},#{y - 1}")
          down = graph.find("#{x},#{y + 1}")

          vertex.add_neighbor(left) if left
          vertex.add_neighbor(right) if right
          vertex.add_neighbor(up) if up
          vertex.add_neighbor(down) if down
        end
      end

      graph
    end
  end
end
