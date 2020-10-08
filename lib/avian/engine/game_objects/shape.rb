class GameObject::Shape < GameObject::Base
  number :color_blend_factor, default: 1.0
  number :color, default: 0xFFFFFF

  def renderable?
    true
  end
end
