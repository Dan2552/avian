module ThetaStar
  class Pathfinder < AStar::Pathfinder
    protected

    def compute_cost(current, neighbor, g_score, came_from)
      if line_of_sight(came_from[current], neighbor)
        if g_score[came_from[current]] + dist_between(came_from[current], neighbor) < g_score[neighbor]
          came_from[neighbor] = came_from[current]
          g_score[neighbor] = g_score[came_from[current]] + dist_between(came_from[current], neighbor)
        end
      else
        if g_score[current] + dist_between(current, neighbor) < g_score[neighbor]
          came_from[neighbor] = current
          g_score[neighbor] = g_score[current] + dist_between(current, neighbor)
        end
      end
    end

    private

    def line_of_sight(lhs, rhs)
      return false unless lhs.present?

      return false if lhs.neighbors.many? { |neighbor| neighbor.nil? || neighbor.blocked? }

      BresenhamLine.iterate_line(lhs, rhs) do |x, y|
        vertex = graph[x, y]

        rel_x = (x - lhs.x).abs
        rel_y = (y - lhs.y).abs
        return false if rel_x == 2 && rel_y == 1
        return false if rel_x == 1 && rel_y == 2
        return false if rel_x == 1 && rel_y == 1

        return false if vertex.neighbors.many? { |neighbor| neighbor.nil? || neighbor.blocked? }

        return false if vertex.nil? || vertex.blocked?
      end

      true
    end
  end
end
