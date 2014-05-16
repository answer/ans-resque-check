module Ans::Resque::Check
  class CheckController < ActionController::Base
    def check
      render text: "done"
    end
  end
end
