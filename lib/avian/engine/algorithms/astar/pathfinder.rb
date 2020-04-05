module AStar
  # A* Pathfinder based on the psudocode on Wikipedia:
  # https://en.wikipedia.org/wiki/A*_search_algorithm
  #
  class Pathfinder
    attr_reader :graph

    # - parameter graph: The graph that pathfinding will occur on.
    # - parameter heuristic: The function used to calculate the heuristic between
    #   vertices. Defaults to `two_dimensional_manhatten_heuristic` when nil is
    #   set.
    #
    def initialize(graph, heuristic = nil)
      @graph = graph
      @heuristic = heuristic || HeuristicFactory.new.two_dimensional_manhatten_heuristic
    end

    # Returns a path from start to goal
    #
    # - parameter start: Vertex of the start of the path
    # - parameter goal: Vertex of where to find the path to
    # - parameter closest_path: Whether to return the closest path, when a
    #   complete path is not found
    # - returns: [Vertex]
    #
    def find_path(start, goal, closest_path = false)
      # The set of nodes already evaluated
      closed_set = [] # [Vertex]

      # The set of current covered nodes that are not evaluated yet.
      # Initially, only the start node is known.
      open_set = [start] # [Vertex]

      # For each node, which node it can most efficiently be reached from.
      # If a node can be reached from many nodes, came_from will eventually
      # contain the most efficient previous step.
      came_from = {} # { Vertex => Vertex }

      # For each node, the cost of getting from the start node to that node.
      g_score = Score.new

      # The cost of going from start to start is zero.
      g_score[start] = 0

      # For each node, the total cost of getting from start node to the goal
      # by passing by that node. That value is partly known, partly heuristic.
      f_score = Score.new

      # For the first node, that value is completely heuristic.
      f_score[start] = heuristic_cost_estimate(start, goal)

      # closest_path
      #
      # Record h so that if we can't find a path, we can return the path to
      # the closest.
      h_score = Score.new
      h_score[start] = heuristic_cost_estimate(start, goal)

      while !open_set.empty?
        # the node in openSet having the lowest f_score[] value
        current = f_score.lowest_of_verteces(open_set).first

        break unless current

        if current == goal
          return reconstruct_path(came_from, current)
        end

        open_set.delete(current)
        closed_set << current

        current.neighbors.each do |neighbor|
          if neighbor.blocked?
            next # Ignore blocked neighbors, as if they aren't there
          end

          if closed_set.include?(neighbor)
            next # Ignore the neighbor which is already evaluated.
          end

          if !open_set.include?(neighbor) # Discover a new node
            open_set << neighbor
          end

          old = g_score[neighbor]

          compute_cost(current, neighbor, g_score, came_from)

          if g_score[neighbor] < old
            f_score[neighbor] = g_score[neighbor] + heuristic_cost_estimate(neighbor, goal)

            # closest_path
            h_score[neighbor] = heuristic_cost_estimate(neighbor, goal)
          end
        end
      end

      # closest_path
      if closest_path
        closest_to_target = h_score.lowest_of_verteces
        if closest_to_target.count > 0
          closest_from_origin = g_score.lowest_of_verteces(closest_to_target).first
          return reconstruct_path(came_from, closest_from_origin) if closest_from_origin
        end
      end

      return [] # Failure; no path found
    end

    protected

    def compute_cost(current, neighbor, g_score, came_from)
      # The distance from start to a neighbor
      tentative_g_score = g_score[current] + dist_between(current, neighbor)
      if tentative_g_score >= g_score[neighbor]
        return # This is not a better path.
      end

      # This path is the best until now. Record it!
      came_from[neighbor] = current
      g_score[neighbor] = tentative_g_score
    end

    private

    attr_reader :heuristic

    # - parameter came_from: { Vertex => Vertex }
    # - parameter current: Vertex
    # - returns: [Vertex]
    #
    def reconstruct_path(came_from, current)
      total_path = [current]
      while came_from.keys.include?(current)
        current = came_from[current]
        total_path << current # TODO: change to prepend rather than append
      end
      total_path.reverse
    end

    # - parameter start: Vertex
    # - parameter goal: Vertex
    # - returns: Double
    #
    def heuristic_cost_estimate(start, goal)
      heuristic.call(start, goal)
    end

    # - parameter start: Vertex
    # - parameter goal: Vertex
    # - returns: Double
    #
    def dist_between(a, b)
      1.0
    end
  end
end
