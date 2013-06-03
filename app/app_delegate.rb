class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    vc = ExampleController.alloc.init
    @window.rootViewController = vc
    @window.makeKeyAndVisible
    true
  end
end
