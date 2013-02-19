require "mongoid-rails-instrumentation/railtie"
require "mongoid-rails-instrumentation/log_subscriber"
module MongoidRailsInstrumentation

  def self.instrument(klass)
    klass.class_eval do 
      def logging(operations)
        instrument_start = (logger = Moped.logger) && logger.debug? && Time.new
        yield
      ensure
        if instrument_start
          instrument_end   = 1000 * (Time.new.to_f - instrument_start.to_f)
          MopedLogSubscriber.runtime += instrument_end
          MopedLogSubscriber.query_count += 1
          log_operations(logger, operations, instrument_end) 
        end
      end
    end
  end

end
