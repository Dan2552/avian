class GameObject::Shape < GameObject::Base
  number :color_blend_factor, default: 1.0
  number :color, default: 0xFFFFFF
  number :opacity, default: 1.0

  def renderable?
    true
  end
end
