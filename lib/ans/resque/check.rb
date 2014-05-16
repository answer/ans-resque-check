require "ans/resque/check/version"

module Ans
  module Resque
    module Check
      class Engine < Rails::Engine
        isolate_namespace Check
      end
    end
  end
end
