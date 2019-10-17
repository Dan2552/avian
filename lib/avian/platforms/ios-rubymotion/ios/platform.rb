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
    def set_scale(*args); shared_instance.set_scale(*args); end
    def set_sprite_visible(*args); shared_instance.set_sprite_visible(*args); end
    def screen_size(*args); shared_instance.screen_size(*args); end
  end

  # The GameScene instance where sprites should be rendered.
  #
  attr_accessor :scene

  # ** Shared **
  #
  # Create a sprite to be stored in the renderer's sprite pool.
  #
  def create_sprite(texture, anchor_point)
    sprite = scene.add_sprite(texture)
    sprite.tap do |s|
      s.anchorPoint = CGPoint.new(anchor_point.x, anchor_point.y)
    end
  end

  # ** Shared **
  #
  def create_texture(texture_name)
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

  # ** Shared **
  #
  def set_sprite_texture(sprite, texture)
    sprite.texture = texture
  end

  def set_sprite_flipped(sprite, flipped_vertically, flipped_horizontally)
    sprite.xScale = 1.0
    sprite.yScale = 1.0
    sprite.xScale = -1.0 if flipped_vertically
    sprite.yScale = -1.0 if flipped_horizontally
  end

  # ** Shared **
  #
  def camera
    scene.camera
  end

  # ** Shared **
  #
  def set_sprite_position(sprite, position, z_position)
    sprite.position = CGPoint.new(position.x, position.y)
    sprite.zPosition = z_position if z_position
  end

  # ** Shared **
  #
  def set_sprite_rotation(sprite, vector)
    sprite.zRotation = Math::Direction.positional_difference(Vector[0, 0], vector) - Math::Direction::UP
  end

  # ** Shared **
  #
  def remove_sprite(sprite)
    sprite.removeFromParent
  end

  # ** Shared **
  #
  def set_scale(sprite, scale)
    sprite.scale = scale
  end

  # ** Shared **
  #
  def screen_size
    @screen_size ||= Size[
      UIScreen.mainScreen.bounds.size.width,
      UIScreen.mainScreen.bounds.size.height
    ]
  end
end
