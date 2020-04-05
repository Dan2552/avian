module AStar
  class Vertex
    attr_reader :name
    attr_accessor :blocked

    # Graph?
    #
    attr_reader :graph

    attr_reader :x
    attr_reader :y

    # - parameter name: An identifier, for your own purposes. Useful for
    #   debugging.
    # - parameter x: (optional) If the vertex is on a grid, this is the x
    #   co-ordinate.
    # - parameter y: (optional) If the vertex is on a grid, this is the y
    #   co-ordinate.
    #
    def initialize(name, x = nil, y = nil)
      @name = name
      @blocked = false
      @x = x
      @y = y
    end

    def to_s
      "v[#{name}]"
    end

    def inspect
      to_s
    end

    # { String => Object }
    #
    def info
      @info ||= {}
    end

    # [Vertex]
    #
    def neighbors
      @neighbors ||= []
    end

    def graph=(new_graph)
      remove_all_neighbors
      if new_graph
        unless @graph == new_graph
          @graph = new_graph
          new_graph.add(self)
        end
      else
        @graph = nil
      end
    end

    def blocked?
      blocked
    end

    def add_neighbor(vertex)
      graph2 = vertex.graph

      if graph != graph2 || graph.nil?
        raise "Verteces must be in the same graph to be linked up."
      end

      neighbors << vertex
      vertex.neighbors << self
    end

    def remove_neighbor(vertex)
      neighbors.delete(vertex)
      vertex.neighbors.delete(self)
    end

    def remove_all_neighbors
      neighbors.each { |v| v.neighbors.delete(self) }
      neighbors.clear
    end
  end
end
