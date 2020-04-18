module ObjectDebugExtension
  def method_missing(meth, *args, &blk)
    raise NoMethodError, "Undefined method '#{meth}' for #{self.class} - #{self.inspect}"
  end
end

Object.class_exec do
  prepend ObjectDebugExtension
end
