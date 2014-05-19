module Ans::Resque::Check
  class ResqueController < ActionController::Base
    def check
      build_info
      report

      render text: @info.join(",")
    end

    private

    def build_info
      @errors = []
      @info = []

      resque.queues.sort_by{|q| q.to_s}.each do |queue|
        check_queue queue
      end

      check_failure
    end
    def report
      if @errors.size > 0
        e = Notice.new @errors.join("\n")
        config.on_notice.each do |method|
          instance_exec e, &method
        end
      end
    end

    def check_queue(queue)
      push_check_info queue.to_s, resque.size(queue), config.queue_notice_threshold
    end
    def check_failure
      push_check_info "failure", ::Resque::Failure.count, config.failed_notice_threshold
    end
    def push_check_info(name,size,threshold)
      info = "#{name}:#{size}"
      @info << info
      @errors << info if size > threshold
    end

    def resque
      ::Resque
    end
    def config
      Ans::Resque::Check.config
    end
  end
end
