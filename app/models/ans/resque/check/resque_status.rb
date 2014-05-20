module Ans::Resque::Check
  class ResqueStatus
    attr_reader :errors, :info

    def initialize(config)
      @config = config
      @errors = []
      @info = []

      resque.queues.sort_by{|q| q.to_s}.each do |queue|
        check_queue queue
      end

      check_failure
    end

    def error?
      @errors.size > 0
    end

    private

    def check_queue(queue)
      push_check_info queue.to_s, resque.size(queue), @config.queue_notice_threshold
    end
    def check_failure
      push_check_info "failure", ::Resque::Failure.count, @config.failed_notice_threshold
    end
    def push_check_info(name,size,threshold)
      info = "#{name}:#{size}"
      @info << info
      @errors << info if size > threshold
    end

    def resque
      ::Resque
    end
  end
end
