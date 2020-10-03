class PlatformRenderer
  def initialize(render_store, camera)
    @render_store = render_store
    @bridge = Avian::CBridge.new
    @camera = camera
  end

  def draw_frame
    bridge.clear_screen
    render_store.sprites.each { |sprite| draw(sprite) }
    render_store.texts.each { |text| draw_text(text) }
    bridge.render
  end

  private

  attr_reader :bridge
  attr_reader :render_store
  attr_reader :camera

  def draw(sprite)
    # TODO: if the object isn't in the camera's view, don't draw it

    return unless sprite.visible

    red = 0
    green = 0
    blue = 0

    if sprite.color_blend_factor > 0
      red = (sprite.color >> 16) & 255
      green = (sprite.color >> 8) & 255
      blue = sprite.color & 255
    end

    bridge.draw_image(
      sprite.texture,
      sprite.x.to_i,
      -sprite.y.to_i,
      sprite.z.to_i,
      0.0, # angle
      sprite.anchor_point.x,
      sprite.anchor_point.y,
      sprite.x_scale.to_f,
      sprite.y_scale.to_f,
      camera.x.to_i,
      -camera.y.to_i,
      camera.x_scale.to_f,
      camera.y_scale.to_f,
      red,
      green,
      blue,
      sprite.color_blend_factor,
      sprite.shadow_texture || -1,
      sprite.shadow_x.to_i,
      sprite.shadow_y.to_i
    )

    sprite.reset!
  end

  def draw_text(text)
    return unless text.text.length > 0

    texture = bridge.create_texture_for_text(
      text.text,
      text.font_size
    )

    sprite = PlatformSprite.new(text.renderable)
    sprite.texture = texture

    draw(sprite)

    bridge.pop_texture
  end
end
