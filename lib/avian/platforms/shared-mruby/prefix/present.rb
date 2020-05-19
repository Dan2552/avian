class Object
  def present?
    !!self
  end
end

class String
  def present?
    strip.length == 0
  end
end

class TrueClass
  def present?
    self
  end
end

class FalseClass
  def present?
    self
  end
end

class Array
  def present?
    !empty?
  end
end

class Hash
  def present?
    !empty?
  end
end
