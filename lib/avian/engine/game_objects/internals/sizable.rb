module GameObject::Internals::Sizable
  extend GameObject::Internals::Attributes

  vector :size, default: Size[0, 0]

  # Returns the frame of the object.
  #
  # Assumes the object's position is based on the center of the frame.
  #
  def frame
    raise "#{self} has no size" unless size

    bottom_left = Vector[
      position.x - (size.width / 2.0),
      position.y - (size.height / 2.0)
    ]

    Rectangle.new(bottom_left, size)
  end
end
