module AStar
  class Graph
    def count
      vertices.count
    end

    # - parameter name: String
    # - returns: Vertex?
    #
    def find(name)
      vertices.each do |vertex|
        return vertex if vertex.name == name
      end
      nil
    end

    # TODO: spec
    #
    # - parameter x: Integer
    # - parameter y: Integer
    # - returns: Vertex?
    #
    def [](x, y)
      x = map[x]
      return nil unless x
      x[y]
    end

    def add(vertex)
      if vertex.graph && vertex.graph != self
        raise "Vertex cannot be in more than one graph."
      end

      return if vertices.include?(vertex)

      # TODO: spec
      if vertex.x != nil && vertex.y != nil
        map[vertex.x] ||= {}
        map[vertex.x][vertex.y] ||= vertex
      end

      vertices << vertex

      vertex.graph = self
    end

    def remove_vertex_named(name)
      vertices
        .select { |v| v.name == name }
        .each { |v| remove(v) }
    end

    def remove(vertex)
      vertex.graph = nil
      vertices.delete(vertex)
      mapped_vertex = (map[vertex.x] || {})[vertex.y]
      map[vertex.x][vertex.y] = nil if mapped_vertex == vertex
    end

    def unblock_all
      vertices.each { |v| v.blocked = false }
    end

    # TODO: spec
    def block_all
      vertices.each { |v| v.blocked = true }
    end

    def inspect
      "#<#{self.class.name}: #{@vertices.count} Verteces>"
    end

    def to_s
      inspect
    end

    private

    # [Vertex]
    #
    def vertices
      @vertices ||= []
    end

    def map
      @map ||= {}
    end
  end
end
