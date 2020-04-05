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

      BresenhamLine.iterate_line(lhs, rhs) do |x, y|
        vertex = graph[x, y]
        return false if vertex.nil? || vertex.blocked?
      end

      true
    end
  end
end
