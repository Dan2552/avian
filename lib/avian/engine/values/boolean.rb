module Boolean
end

class TrueClass
  include Boolean
  extend Boolean

  def value
    true
  end
end

class FalseClass
  include Boolean
  extend Boolean

  def value
    false
  end
end
