module MongoidRailsInstrumentation
  class Railtie < Rails::Railtie
    initializer "moped.instrumentation" do |app|
      MongoidRailsInstrumentation.instrument Moped::Node
      MongoidRailsInstrumentation::MopedLogSubscriber.attach_to :action_controller
    end
  end
end