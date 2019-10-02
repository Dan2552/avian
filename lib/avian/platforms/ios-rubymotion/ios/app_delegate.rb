class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    rootViewController = GameViewController.alloc.init

    # This keeps the iOS device from going to sleep.
    UIApplication.sharedApplication.setIdleTimerDisabled(true)

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = rootViewController
    @window.makeKeyAndVisible

    true
  end
end
