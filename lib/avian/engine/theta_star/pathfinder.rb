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
      x0 = lhs.x
      y0 = lhs.y
      x1 = rhs.x
      y1 = rhs.y
      dy = y1 - y0
      dx = x1 - x0
      f = 0
      if dy < 0
        dy = -dy
        sy = -1
      else
        sy = 1
      end
      if dx < 0
        dx = -dx
        sx = -1
      else
        sx = 1
      end
      if dx >= dy
        while x0 != x1
          f = f + dy
          if f >= dx
            if graph[x0 + ((sx - 1) / 2), y0 + ((sy - 1) / 2)]
              return false
            end
            y0 = y0 + sy
            f = f - dx
          end
          if f != 0 && graph[x0 + ((sx - 1) / 2), y0 + ((sy - 1) / 2)]
            return false
          end
          if dy == 0 && graph[x0 + ((sx - 1) / 2), y0] && graph[x0 + ((sx - 1) / 2), y0 - 1]
            return false
          end
          x0 = x0 + sx
        end
      else
        while y0 != y1
          f = f + dx
          if f >= dy
            if graph[x0 + ((sx - 1) / 2), y0 + ((sy - 1) / 2)]
              return false
            end
            x0 = x0 + sx
            f = f - dy
          end
          if f != 0 && graph[x0 + ((sx - 1) / 2), y0 + ((sy - 1) / 2)]
            return false
          end
          if dx == 0 && graph[x0, y0 + ((sy - 1) / 2)] && graph[x0 - 1, y0 + ((sy - 1) / 2)]
            return false
          end
          y0 = y0 + sy
        end
      end
      return true
    end
  end
end
