module MongoidRailsInstrumentation
  class MopedLogSubscriber < ActiveSupport::LogSubscriber
    def self.runtime=(value)
      Thread.current["moped_rails_runtime"] = value
    end

    def self.runtime
      Thread.current["moped_rails_runtime"] ||= 0
    end

    def self.query_count=(value)
      Thread.current["moped_rails_query_count"] = value
    end

    def self.query_count
      Thread.current["moped_rails_query_count"] ||= 0
    end

    def self.reset_runtime!
      rt, self.runtime = runtime, 0
      self.query_count = 0
      rt
    end

    def moped(duration)
      self.class.runtime += duration
    end

    def start_processing(event)
      MopedLogSubscriber.reset_runtime!
    end

    def process_action(event)
      runtime = ("Mongo: (%.4fms) | Query count: #{MopedLogSubscriber.query_count}" % MopedLogSubscriber.runtime)
      info(runtime)
    end

    def logger
      ActionController::Base.logger
    end
  end 
end