class GameViewController < UIViewController
  def viewDidLoad
    super

    self.view = sk_view
    view.showsFPS = true

    @scene = GameScene.sceneWithSize(sk_view.frame.size)
    sk_view.presentScene @scene
  end

  def sk_view
    screen_rect = CGRectMake(
      0,
      0,
      UIScreen.mainScreen.bounds.size.width,
      UIScreen.mainScreen.bounds.size.height
    )

    @sk_view ||= SKView.alloc.initWithFrame(screen_rect)
  end

  def prefersStatusBarHidden
    true
  end
end
