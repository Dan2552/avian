module ValueClass
  def from_value(value)
    new(value)
  end
end

module Value
  def self.included(mod)
    mod.extend(ValueClass)
  end

  def initialize(value)
    @value = value
  end

  def value
    @value
  end
end

class String
  def self.from_value(value)
    value
  end

  def value
    self
  end
end

class Numeric
  def self.from_value(value)
    value
  end

  def value
    self
  end
end
