class Vector
  attr_reader :x
  attr_reader :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def self.[](x, y)
    new(x, y)
  end

  def zero?
    x.zero? && y.zero?
  end

  def ==(other)
    return false unless other.is_a? self.class
    x == other.x && y == other.y
  end

  def eql?(other)
    self == other
  end

  # Vector + Vector
  #
  def +(v)
    self.class[x + v.x, y + v.y]
  end

  # Vector - Vector
  #
  def -(v)
    self.class[x - v.x, y - v.y]
  end

  # Vector * number
  #
  def *(n)
    self.class[x * n, y * n]
  end

  # Vector / number
  #
  def /(n)
    self.class[x / n, y / n]
  end

  def +@
    self
  end

  def -@
    self.class[-x, -y]
  end

  def magnitude
    Math::Distance.accurate_distance(self.class[0,0], self)
  end

  def normalize
    n = magnitude
    raise "Zero magnitude vectors can't be normalized" if n == 0
    self / n
  end

  def to_s
    "#{self.class}[#{x},#{y}]"
  end

  def inspect
    to_s
  end
end
