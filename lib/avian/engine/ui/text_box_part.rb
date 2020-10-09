class TextBoxPart < GameObject::Text
  belongs_to :text_box

  vector :renderable_anchor_point, default: Vector[0.0, 1.0]
  vector :relative_position, default: Vector[0, 0]

  def position
    text_box.position + relative_position
  end
end
