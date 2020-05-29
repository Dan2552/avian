class Array
  # Basically `collection.size > 1`
  #
  # If a block given, many? only takes into account those elements that return
  # true
  #
  def many?(&blk)
    count = 0

    each do |element|
      if block_given?
        count += 1 if yield(element)
      else
        count += 1
      end
      return true if count > 1
    end

    false
  end
end
