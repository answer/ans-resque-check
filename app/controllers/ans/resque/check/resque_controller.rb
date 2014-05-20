module Ans::Resque::Check
  class ResqueController < ActionController::Base
    def check
      status = ResqueStatus.new(config)
      report status if status.error?
      render text: status.info.join(",")
    end

    private

    def report(status)
      e = Notice.new status.errors.join("\n")
      config.on_notice.each do |method|
        instance_exec e, &method
      end
    end

    def config
      Ans::Resque::Check.config
    end
  end
end
