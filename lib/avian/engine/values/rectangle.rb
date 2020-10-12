class Rectangle
  attr_reader :origin,
              :size

  def initialize(origin, size)
    @origin = origin.clone
    @size = size
  end

  def contains?(point)
    point.x > left &&
      point.x < right &&
      point.y < top &&
      point.y > bottom
  end

  def intersects?(comparison)
    intersection(comparison) != nil
  end

  def inspect
    "#<Rectangle:#{origin},#{size}>"
  end

  def to_s
    inspect
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
    raise "comparison must be a rectangle" unless comparison.is_a?(Rectangle)
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

  def top_left
    Vector[left, top]
  end

  def top_right
    Vector[right, top]
  end

  def bottom_left
    Vector[left, bottom]
  end

  def bottom_right
    Vector[right, bottom]
  end

  def center
    Vector[
      origin.x + (size.width * 0.5),
      origin.y + (size.height * 0.5)
    ]
  end

  def top_center
    Vector[origin.x + (size.width * 0.5), top]
  end

  def bottom_center
    Vector[origin.x + (size.width * 0.5), bottom]
  end

  def left_center
    Vector[left, origin.y + (size.height * 0.5)]
  end

  def right_center
    Vector[left, origin.y + (size.height * 0.5)]
  end
end
