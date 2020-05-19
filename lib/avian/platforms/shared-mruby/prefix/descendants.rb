class Class
  def descendants
    arr = []
    ObjectSpace.each_object(Class) do |cl|
      arr << cl if cl != self && cl.ancestors.include?(self)
    end
    arr
  end
end
