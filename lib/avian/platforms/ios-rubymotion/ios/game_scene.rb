class GameScene < SKScene
  def didMoveToView(view)
    @strong_camera_reference = SKCameraNode.new
    Platform.shared_instance.scene = self

    view.showsFPS = true
    view.multipleTouchEnabled = true
    view.ignoresSiblingOrder = true
    self.scaleMode = SKSceneScaleModeAspectFit
    # self.backgroundColor = UIColor.whiteColor
    self.backgroundColor = UIColor.alloc.initWithRed(0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1)
    self.camera = @strong_camera_reference

    config = Avian::Application.main.config
    primary_scene = config.primary_scene
    @scenario = primary_scene.new
    @loop ||= Loop.new(@scenario.root)
  end

  # - parameter texture: SKTexture.textureWithImageNamed(path)
  #
  def add_sprite(texture)
    sprite = SKSpriteNode.spriteNodeWithTexture(texture)
    sprite.size = CGSize.new(sprite.size.width * 0.5,
                             sprite.size.height * 0.5)
    addChild(sprite)
    sprite
  end

  def update(currentTime)
    loop.perform_update(currentTime * 1000)
  end

  # - parameter touches: Collection of UITouch
  #
  def touchesBegan(touches, withEvent: event)
    touches.each do |touch|
      Input.shared_instance.touch_did_begin(touch.hash, touch_to_position(touch))
    end
  end

  # - parameter touches: Collection of UITouch
  #
  def touchesEnded(touches, withEvent: event)
    touches.each do |touch|
      Input.shared_instance.touch_did_end(touch.hash, touch_to_position(touch))
    end
  end

  # - parameter touches: Collection of UITouch
  #
  def touchesMoved(touches, withEvent: event)
    touches.each do |touch|
      Input.shared_instance.touch_did_move(touch.hash, touch_to_position(touch))
    end
  end

  private

  attr_reader :loop

  def touch_to_position(touch)
    point = touch.locationInView(view)
    Vector[point.x, UIScreen.mainScreen.bounds.size.height - point.y]
  end
end
