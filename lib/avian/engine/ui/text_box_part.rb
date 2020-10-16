class TextBoxPart < GameObject::Text
  belongs_to :text_box

  vector :renderable_anchor_point, default: Vector[0.0, 1.0]
  vector :relative_position, default: Vector[0, 0]

  attribute :instructions, default: []

  def position
    text_box.position + relative_position
  end

  def z_position
    text_box.z_position
  end

  def visible
    text_box.visible
  end
end
