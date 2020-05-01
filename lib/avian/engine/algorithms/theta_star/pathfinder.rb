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
        return false if vertex.nil?

        rel_x = (x - lhs.x)
        rel_y = (y - lhs.y)

        if rel_x == 0 && rel_y == 0
          return true
        end

        if rel_x == 2 && rel_y == 1
          check = graph[lhs.x + 1, lhs.y + 1]

          return false if check.nil? || check.blocked?
        end

        if rel_x == -2 && rel_y == 1
          check = graph[lhs.x - 1, lhs.y + 1]

          return false if check.nil? || check.blocked?
        end

        if rel_x == 1 && rel_y == 2
          check = graph[lhs.x + 1, lhs.y + 1]

          return false if check.nil? || check.blocked?
        end

        if rel_x == 1 && rel_y == -2
          check = graph[lhs.x + 1, lhs.y - 1]

          return false if check.nil? || check.blocked?
        end

        if rel_x == 1 && rel_y == 1
          check1 = graph[lhs.x, lhs.y + 1]

          return false if check1.nil? || check1.blocked?

          check2 = graph[lhs.x + 1, lhs.y]

          return false if check2.nil? || check2.blocked?
        end

        if rel_x == -1 && rel_y == -1
          check1 = graph[lhs.x, lhs.y - 1]

          return false if check1.nil? || check1.blocked?

          check2 = graph[lhs.x - 1, lhs.y]

          return false if check2.nil? || check2.blocked?
        end

        if rel_x == 1 && rel_y == -1
          check1 = graph[lhs.x, lhs.y - 1]

          return false if check1.nil? || check1.blocked?

          check2 = graph[lhs.x + 1, lhs.y]

          return false if check2.nil? || check2.blocked?
        end

        if rel_x == -1 && rel_y == 1
          check1 = graph[lhs.x - 1, lhs.y]

          return false if check1.nil? || check1.blocked?

          check2 = graph[lhs.x, lhs.y + 1]

          return false if check2.nil? || check2.blocked?
        end

        return false if vertex.neighbors.many? { |neighbor| neighbor.nil? || neighbor.blocked? }

        return false if vertex.nil? || vertex.blocked?
      end

      true
    end
  end
end
