module GameObject::Internals::Renderable
  extend GameObject::Internals::Attributes

  boolean :relative_to_camera, default: false
  boolean :flipped_horizontally, default: false
  boolean :flipped_vertically, default: false
  boolean :renderable, default: false
  vector :renderable_anchor_point, default: Vector[0.5, 0.5]

  def sprite_name
    @sprite_name ||= self.class.to_s.demodulize.underscore.downcase
  end

  # The position that is used to render. This can be overridden specifically
  # to override the position something is rendered at without affecting it's
  # actual position.
  #
  def renderable_position
    position
  end

  def renderable_z_position
    z_position
  end
end
