class Log < Motion::Log
  extend LoggerClassMethods

  attr_accessor :async, :level

  class << self
    def config(&block)
      block.call(self)
    end

    def addLogger(logger)
      super

      Log.info("#{logger.class} Added")
      Log.info("Log Path: #{log_path(logger)}") if logger.class == DDFileLogger

      loggers << logger
    end

    def removeAllLoggers
      super

      loggers.clear
    end

    def loggers
      @loggers ||= []
    end

    private

    def log_path(file_logger)
      file_logger.logFileManager.unsortedLogFilePaths.last
    end
  end
end
