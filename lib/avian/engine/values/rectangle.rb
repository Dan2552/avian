class Rectangle
  attr_reader :origin,
              :size

  def initialize(origin, size)
    @origin = origin.clone
    @size = size
  end

  def inside?(point)
    point.x > left &&
      point.x < right &&
      point.y < top &&
      point.y > bottom
  end

  def intersects?(comparison)
    intersection(comparison) != nil
  end

  # The intersection of two rectangles is the rectangle where the two overlap.
  # Because of that, you want a rectangle with:
  #
  # - The rightmost of the left-hand sides,
  # - The leftmost of the right-hand sides,
  # - The bottommost of the tops, and
  # - The topmost of the bottoms.
  #
  # In other words, you want the left, right, top, and bottom that are the
  # closest to the center, but calculating it that way is excessive. So, those
  # are your four x_min (et al) lines.
  #
  # However, if the rectangles don't overlap at all, there isn't an
  # intersection. That's your return nil line. How do we know there's no
  # overlap? The right and left or the top and bottom aren't where we expect
  # them to be.
  #
  # The last line just assembles the coordinates (from the first four lines)
  # into the upper-left and lower-right points as specified.
  #
  def intersection(comparison)
    x_min = [left, comparison.left].max
    x_max = [right, comparison.right].min

    y_min = [bottom, comparison.bottom].max
    y_max = [top, comparison.top].min

    return nil if ((x_max < x_min) || (y_max < y_min))
    return [[x_min, y_min], [x_max, y_max]]
  end

  def left
    origin.x
  end

  def right
    origin.x + size.width
  end

  def top
    origin.y + size.height
  end

  def bottom
    origin.y
  end
end