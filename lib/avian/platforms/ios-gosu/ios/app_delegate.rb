class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    UIApplication.sharedApplication.setIdleTimerDisabled(true)
    size = UIScreen.mainScreen.bounds.size
    @window = Avian::IOSGosuPlatform::Window.new(size.width, size.height)
    @window.uikit_window.makeKeyAndVisible
    true
  end
end
