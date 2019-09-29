module Math
  module Distance
    # Returns an actual distance between 2 points.
    #
    # I.e. uses Pythagorous theorem with square root.
    #
    # - parameter origin: Object that responds to x and y
    # - parameter comparison: Object that responds to x and y
    #
    def accurate_distance(origin, comparison)
      x1 = origin.x
      x2 = comparison.x

      y1 = origin.y
      y2 = comparison.y

      Math.sqrt((x2 - x1) ** 2 + (y2 - y1) ** 2)
    end
    module_function :accurate_distance

    # Returns a distance that should be used when comparing one distance to
    # another.
    #
    # I.e. to avoid using square root.
    #
    # - parameter origin: Object that responds to x and y
    # - parameter comparison: Object that responds to x and y
    #
    def quick_distance(origin, comparison)
      x1 = origin.x
      x2 = comparison.x

      y1 = origin.y
      y2 = comparison.y

      (x2 - x1) ** 2 + (y2 - y1) ** 2
    end
    module_function :quick_distance

    # Returns the index of the object from the collection that is the closest
    # (positionally) to the comparison co-ordinates.
    #
    # If the comparison is included in the collection it is ignored.
    #
    # - parameter collection: Array of objects that respond to x and y
    # - parameter comparison: Object that responds to x and y
    #
    def lowest_distance(collection, comparison)
      new_target = -1
      distance_to_new_target = Float::MAX

      collection.each.with_index do |element, index|
        next if element.equal?(comparison)

        iteration_distance = quick_distance(element, comparison)

        if iteration_distance < distance_to_new_target
          new_target = index
          distance_to_new_target = iteration_distance
        end
      end

      new_target
    end
    module_function :lowest_distance
  end
end
