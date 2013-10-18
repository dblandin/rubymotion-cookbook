class AppDelegate
  attr_reader :window

  def application(application, didFinishLaunchingWithOptions: launch_options)
    return true if RUBYMOTION_ENV == 'test'

    initialize_logging
    configure_navigator
    initialize_main_controller

    Navigator.shared.open('main')

    true
  end

  private

  def initialize_main_controller
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    window.setRootViewController(Navigator.shared.navigation_controller)

    window.makeKeyAndVisible
  end

  def configure_navigator
    Navigator.config do |navigator|
      navigator.register_nav_controller(UINavigationController.new)

      navigator.map do |router|
        router.map('main', ViewController, shared: true)
      end
    end
  end

  def initialize_logging
    level = RUBYMOTION_ENV == 'development' ? :debug : :error

    enable_logging(level)

    Log.info("Logging enabled. Level: #{Log.level}")
  end

  def enable_logging(level = :debug)
    Log.config do |logger|
      logger.level = level
      logger.async = true
      logger.addLogger file_logger

      if level == :debug
        logger.addLogger DDTTYLogger.sharedInstance
      end
    end
  end

  def file_logger
    @file_logger ||= DDFileLogger.new.tap do |file_logger|
      file_logger.rollingFrequency = 60 * 60 * 24
      file_logger.logFileManager.maximumNumberOfLogFiles = 1
    end
  end
end
