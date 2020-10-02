class GameObject::Text < GameObject::Base
  string :font_name, default: "Arial"
  string :text
  number :font_size, default: 32
  number :color, default: 0xffffff
  number :color_blend_factor, default: 1.0

  def renderable?
    true
  end
end
