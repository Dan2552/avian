# Platform should abstract away anything that the shared code needs to call
# upon in order to keep things loosely coupled.
#
# This class should be specifically written for each platform.
#
# All methods that should be defined on each platform are labelled ** Shared **.
#
class Platform
  class << self
    def shared_instance
      @shared_instance ||= new
    end

    def create_sprite(*args); shared_instance.create_sprite(*args); end
    def create_texture(*args); shared_instance.create_texture(*args); end
    def set_sprite_texture(*args); shared_instance.set_sprite_texture(*args); end
    def create_text(*args); shared_instance.create_text(*args); end
    def set_text_attributes(*args); shared_instance.set_text_attributes(*args); end
    def camera(*args); shared_instance.camera(*args); end
    def set_sprite_position(*args); shared_instance.set_sprite_position(*args); end
    def set_sprite_rotation(*args); shared_instance.set_sprite_rotation(*args); end
    def set_sprite_flipped(*args); shared_instance.set_sprite_flipped(*args); end
    def remove_sprite(*args); shared_instance.remove_sprite(*args); end
    def set_sprite_scale(*args); shared_instance.set_sprite_scale(*args); end
    def set_sprite_visible(*args); shared_instance.set_sprite_visible(*args); end
    def set_sprite_color_blend(*args); shared_instance.set_sprite_color_blend(*args); end
    def screen_size(*args); shared_instance.screen_size(*args); end
  end

  # The GameScene instance where sprites should be rendered.
  #
  attr_accessor :scene

  # Create a sprite to be stored in the renderer's sprite pool.
  #
  def create_sprite(texture, anchor_point)
    sprite = scene.add_sprite(texture)
    sprite.tap do |s|
      s.anchorPoint = CGPoint.new(anchor_point.x, anchor_point.y)
    end
  end



  def create_texture(texture_name)
    if texture_name.start_with?("dungeon/")
      number = texture_name.split("dungeon/dungeon").last.to_i
      @dungeon ||= SKTexture.textureWithImageNamed("dungeon.png")
      row = number / 8
      col = number % 8
      width = 1.0 / 8
      height = 1.0 / 8

      rect = CGRectMake(width * col, 1 - (height * (row + 1)), 0.125, 0.125)
      return SKTexture.textureWithRect(rect, inTexture: @dungeon);
    end

    SKTexture.textureWithImageNamed("#{texture_name}.png")
  end

  def create_text(font_name)
    text = SKLabelNode.labelNodeWithFontNamed(font_name)
    text.tap do |t|
      scene.addChild(text)
    end
  end

  # TODO: make it support color hashes instead
  FONT_COLORS = {
    "black" => UIColor.blackColor,
    "white" => UIColor.whiteColor
  }

  def set_sprite_visible(sprite, visible)
    sprite.hidden = !visible
  end

  def set_text_attributes(node, text, font_size, font_color, x, y)
    node.text = text
    node.fontSize = font_size
    node.fontColor = FONT_COLORS[font_color]
    node.position = CGPoint.new(x, y)
  end

  def set_sprite_texture(sprite, texture)
    sprite.texture = texture
  end

  def set_sprite_flipped(sprite, flipped_vertically, flipped_horizontally)
    sprite.xScale = 1.0
    sprite.yScale = 1.0
    sprite.xScale = -1.0 if flipped_vertically
    sprite.yScale = -1.0 if flipped_horizontally
  end

  def camera
    scene.camera
  end

  def set_sprite_position(sprite, position, z_position)
    new_position = CGPoint.new(position.x, position.y)
    sprite.position = new_position if sprite.position != new_position
    sprite.zPosition = z_position if z_position && z_position != sprite.zPosition
  end

  def set_sprite_rotation(sprite, vector)
    sprite.zRotation = Math::Direction.positional_difference(Vector[0, 0], vector) - Math::Direction::UP
  end

  def remove_sprite(sprite)
    sprite.removeFromParent
  end

  def set_sprite_scale(sprite, x_scale, y_scale)
    if sprite.is_a?(SKCameraNode)
      sprite.scale = y_scale
    else

      sprite.xScale = x_scale if sprite.xScale != x_scale
      sprite.yScale = y_scale if sprite.yScale != y_scale
    end
  end

  def set_sprite_color_blend(sprite, color, blend_factor)
    r = ((color & 0xff0000) >> 16) / 255
    g = ((color & 0x00ff00) >> 8) / 255
    b = (color & 0x0000ff) / 255
    sprite.color = UIColor.alloc.initWithRed(r, green: g, blue: b, alpha: 1)
    sprite.colorBlendFactor = blend_factor
  end

  def screen_size
    @screen_size ||= Size[
      UIScreen.mainScreen.bounds.size.width,
      UIScreen.mainScreen.bounds.size.height
    ]
  end
end
