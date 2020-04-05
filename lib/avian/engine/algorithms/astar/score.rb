module AStar
  # Stores scores (i.e. for g or f) and returns Infinity by default.
  #
  class Score
    def [](vertex)
      return Float::INFINITY unless vertex
      return store[vertex] || Float::INFINITY
    end

    def []=(vertex, value)
      store[vertex] = value
    end

    # Returns the verteces with the lowest value.
    #
    # If more than one vertex shares the same lowest value, more than one will
    # be returned.
    #
    # - parameter verteces: [Vertex]?
    # - returns: [Vertex]
    #
    def lowest_of_verteces(verteces = nil)
      # Vertex?
      lowest_so_far = nil

      # [Vertex]
      return_value = []

      verteces = verteces || store.keys

      verteces.each do |vertex|
        value_vertex = self[vertex]
        value_lsf = self[lowest_so_far]

        if value_vertex < value_lsf
          lowest_so_far = vertex
          return_value = [vertex]
        elsif value_vertex == value_lsf
          return_value << vertex
        end
      end

      return return_value
    end

    def to_s
      self.class.name
    end

    private

    # { Vertex => Double }
    #
    def store
      @store ||= {}
    end
  end
end
