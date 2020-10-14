class Time
  class << self
    attr_writer :delta

    def delta
      @delta ||= 0
    end
  end
end

module TimeHelpers
  def seconds
    Duration.new(self, :second)
  end

  def second
    seconds
  end

  def milliseconds
    Duration.new(self, :millisecond)
  end

  def millisecond
    milliseconds
  end
end

class Integer
  include TimeHelpers
end

class Float
  include TimeHelpers
end

class Duration
  def initialize(time, type)
    @time = time
    @type = type
  end

  def seconds
    case @type
    when :second
      self
    when :millisecond
      Duration.new(@time * 0.001, :second)
    end
  end

  def milliseconds
    case @type
    when :second
      Duration.new(@time / 0.001, :millisecond)
    when :millisecond
      self
    end
  end

  def to_i
    if @type == :second
      @time.to_i
    else
      seconds.to_i
    end
  end

  def to_f
    if @type == :second
      @time.to_f
    else
      seconds.to_f
    end
  end

  def inspect
    if @time == 1
      "#{@time} #{@type}"
    else
      "#{@time} #{@type}s"
    end
  end
end
