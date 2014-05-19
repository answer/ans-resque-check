require "ans/resque/check/version"

module Ans
  module Resque
    module Check
      include ActiveSupport::Configurable

      configure do |config|
        config.queue_notice_threshold = 500
        config.failed_notice_threshold = 0
        config.on_notice = []
      end

      class Engine < Rails::Engine
        isolate_namespace Check
      end
      class Notice < StandardError
      end
    end
  end
end
